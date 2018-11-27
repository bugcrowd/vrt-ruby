require 'spec_helper'

describe VRT do
  let(:dir) { described_class::DIR }

  # Make sure we're not caching values in memory from previous specs. ;)
  before { described_class.reload! }

  # Make sure specs that run after us don't inherit our stubbed-out, cached
  # values
  after { described_class.unload! }

  describe '#versions' do
    it 'return all of the versions in the filesystem in reverse semver order' do
      expect(described_class.versions).to eq(['999.999', '2.0', '1.0'])
    end
  end

  describe '#current_version' do
    it 'return the most recent version number for the vrt' do
      expect(described_class.current_version).to eq('999.999')
    end
  end

  describe '#get_json' do
    it 'takes a vrt version number and returns parsed json data from the appropriate file' do
      expect(described_class.get_json(version: '1.0')).to be_a(Array)
    end

    it 'adds an Other category to the VRT if other is true' do
      expect(described_class.get_json(version: '1.0', other: true)).to include(described_class::OTHER_OPTION)
    end
  end

  describe '#get_map' do
    it 'takes a vrt version number and returns a VRT::Map' do
      expect(described_class.get_map(version: '1.0')).to be_a(VRT::Map)
    end

    it 'only creates the map once' do
      expect(VRT::Map).to receive(:new).once.and_return('dummy map')
      expect(described_class.get_map(version: '1.0')).to eq('dummy map')
      expect(described_class.get_map(version: '1.0')).to eq('dummy map')
    end
  end

  describe '#last_update' do
    it 'shows the last updated time from version metadata' do
      expect(described_class.last_updated).to eq Date.parse('Tue, 17 Feb 3001')
    end
  end

  describe '#current_categories' do
    subject { described_class.current_categories }

    let!(:category) do
      subject.select { |cat| cat[:value] == :server_security_misconfiguration }.first
    end

    it 'uses the newest names for the same key' do
      expect(category[:label]).to eq 'Server Security Misconfiguration (1.1)'
    end

    it 'does not contain duplicate keys' do
      expect(subject.uniq { |cat| cat[:value] }).to eq subject
    end
  end

  describe '#find_node' do
    subject(:found_node) do
      described_class.find_node(
        vrt_id: vrt_id,
        preferred_version: new_version,
        max_depth: max_depth
      )
    end

    let(:new_version) { nil }
    let(:max_depth) { 'variant' }

    context 'when vrt_id exists' do
      let(:vrt_id) { 'server_security_misconfiguration.unsafe_cross_origin_resource_sharing' }

      context 'and no preferred version given' do
        it 'should return the node with the same id in the latest version' do
          expect(found_node.qualified_vrt_id).to eq vrt_id
          expect(found_node.version).to eq described_class.current_version
        end
      end

      context 'and preferred version given' do
        let(:new_version) { '2.0' }

        it 'should return the node with the same id in the preferred version' do
          expect(found_node.qualified_vrt_id).to eq vrt_id
          expect(found_node.version).to eq new_version
        end
      end

      context 'and max_depth given' do
        let(:max_depth) { 'category' }

        it 'should return the node in the latest version at given max_depth' do
          expect(found_node.qualified_vrt_id).to eq vrt_id.split('.')[0]
          expect(found_node.version).to eq described_class.current_version
        end
      end
    end

    context 'when vrt_id is deprecated' do
      let(:vrt_id) { 'unvalidated_redirects_and_forwards.open_redirect.get_based_authenticated' }
      let(:expected_found_id) { 'unvalidated_redirects_and_forwards.open_redirect.get_based' }

      context 'and has mapping in preferred version' do
        let(:new_version) { '2.0' }

        it 'should return the node mapped from the deprecated node in the preferred version' do
          expect(found_node.qualified_vrt_id).to eq expected_found_id
          expect(found_node.version).to eq new_version
        end
      end

      context 'but given preferred is newer than deprecated entry' do
        let(:new_version) { '999.999' }

        it 'should return the node mapped from the deprecated node in the preferred version' do
          expect(found_node.qualified_vrt_id).to eq expected_found_id
          expect(found_node.version).to eq new_version
        end
      end

      context 'due to category change and max_depth is supplied' do
        let(:vrt_id) { 'unvalidated_redirects_and_forwards.lack_of_security_speed_bump_page' }
        let(:max_depth) { 'category' }

        it 'should return the node mapped from the deprecated node in the preferred version' do
          expect(found_node.qualified_vrt_id).to eq 'external_behavior'
          expect(found_node.version).to eq described_class.current_version
        end
      end
    end

    context 'when vrt_id is not found in deprecated node mapping' do
      context 'and has a valid parent node' do
        let(:vrt_id) { 'sensitive_data_exposure.token_leakage_via_referer.over_https' }
        let(:new_version) { '999.999' }

        it 'should return the most relevant parent node' do
          expect(found_node.qualified_vrt_id).to eq 'sensitive_data_exposure.token_leakage_via_referer'
        end

        context 'with max_depth given' do
          let(:max_depth) { 'category' }

          it 'should return the parent node at the specified depth' do
            expect(found_node.qualified_vrt_id).to eq 'sensitive_data_exposure'
          end
        end
      end

      context 'has valid parent two levels up' do
        let(:vrt_id) { 'insecure_data_storage.insecure_data_storage.password' }
        let(:new_version) { '999.999' }

        it 'should return top level category' do
          expect(found_node.qualified_vrt_id).to eq 'insecure_data_storage'
        end
      end

      context 'and has no valid parent node' do
        let(:vrt_id) { 'sensitive_data_exposure.token_leakage_via_referer.over_https' }
        let(:new_version) { '2.0' }

        it 'should return nil' do
          expect(found_node).to be_nil
        end
      end

      context 'when found node is also deprecated' do
        let(:vrt_id) { 'unvalidated_redirects_and_forwards.open_redirect.get_based_all_users' }
        let(:new_version) { '999.999' }

        it 'should retrieve the deeply nested deprecated mapping' do
          expect(found_node.qualified_vrt_id).to eq 'unvalidated_redirects_and_forwards.open_redirect.get_based'
        end
      end
    end
  end

  describe '#all_matching_categories' do
    subject(:full_search_list) { described_class.all_matching_categories(categories) }

    context 'with deprecated other category' do
      let(:categories) { %w[external_behavior other] }
      let(:deprecated) do
        %w[
          poor_physical_security
          social_engineering
          unvalidated_redirects_and_forwards.lack_of_security_speed_bump_page
        ]
      end

      it 'should return a list containing the deprecated categories' do
        expect(full_search_list).to contain_exactly(*deprecated)
      end
    end

    context 'with subcategories included' do
      let(:categories) do
        %w[
          external_behavior
          other
          unvalidated_redirects_and_forwards.open_redirect
        ]
      end
      let(:deprecated) do
        %w[
          poor_physical_security
          social_engineering
          unvalidated_redirects_and_forwards.lack_of_security_speed_bump_page
          unvalidated_redirects_and_forwards.open_redirect.get_based_all_users
          unvalidated_redirects_and_forwards.open_redirect.get_based_unauthenticated
          unvalidated_redirects_and_forwards.open_redirect.get_based_authenticated
          unvalidated_redirects_and_forwards.open_redirect.get_based_thingo
        ]
      end

      it 'should return a list containing the deprecated categories' do
        expect(full_search_list).to contain_exactly(*deprecated)
      end
    end
  end

  describe '#current_version?' do
    subject(:current_version) { described_class.current_version?(version) }

    context 'when version is current' do
      let(:version) { '999.999' }

      it { is_expected.to be }
    end

    context 'when version is not current' do
      let(:version) { '2.0' }

      it { is_expected.to be false }
    end
  end
end
