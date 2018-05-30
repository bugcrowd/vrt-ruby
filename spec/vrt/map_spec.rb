require 'spec_helper'

describe VRT::Map do
  let(:vrt) { VRT }
  let(:dir) { vrt::DIR }
  let(:sample_map) { described_class.new('999.999') }

  before do
    VRT.unload!
    allow(vrt).to receive(:current_version).and_return('2.0')
  end

  after { VRT.unload! }

  context 'with no argument' do
    let(:current_map) { described_class.new }

    it 'creates a VRT Map using the current version' do
      expect(current_map.version).to eq('2.0')
    end
  end

  context 'with an argument' do
    it 'creates a VRT Map using a specific version' do
      expect(sample_map.version).to eq('999.999')
    end
  end

  describe '#build_structure' do
    it 'builds a valid hash for the VRT structure on instantiation' do
      expect(sample_map.structure).to include(:server_side_injection)
      expect(sample_map.structure[:server_side_injection]).to be_a(VRT::Node)
    end
  end

  context 'when the structure is queried' do
    let(:good_query) { 'server_side_injection.sql_injection.blind' }
    let(:sneaky_query) { 'server_side_injection.sql_injection.blind.sneaky_guy' }
    let(:bad_query) { 'ssl_attack_breach_poodle_etc.unsafe_cross_origin_resource_sharing.critical_impact' }

    it 'finds a category when given a query string' do
      node = sample_map.find_node(good_query)
      expect(node).to be_a(VRT::Node)
      expect(node.id).to eq(:blind)
    end

    it 'can determine the validity of a given query string' do
      expect(sample_map.valid?(good_query)).to be_truthy
      expect(sample_map.valid?(sneaky_query)).to be_falsey
      expect(sample_map.valid?(bad_query)).to be_falsey
    end
  end

  describe '#find_node' do
    subject { sample_map.find_node(vrt_id) }

    context 'when vrt_id is nil' do
      let(:vrt_id) { nil }

      it { is_expected.to be_nil }
    end

    context 'when vrt_id is not a valid identifier' do
      let(:vrt_id) { "I'm not valid" }

      it { is_expected.to be_nil }
    end

    context 'when vrt_id is not a string' do
      let(:vrt_id) { 55 }

      it { is_expected.to be_nil }
    end

    context 'when vrt_id is a valid identifier' do
      context 'vrt_id does not exist in version' do
        let(:vrt_id) { 'cool_new_concept' }

        it { is_expected.to be_nil }
      end

      context 'vrt_id exists in version' do
        context 'vrt_id is category level' do
          let(:vrt_id) { 'server_security_misconfiguration' }

          it { is_expected.to be_a(VRT::Node) }
        end

        context 'vrt_id is a variant' do
          let(:vrt_id) { 'server_security_misconfiguration.using_default_credentials.production_server' }

          it { is_expected.to be_a(VRT::Node) }
        end
      end
    end
  end

  describe '#get_lineage' do
    context 'with a complex hierarchy' do
      let(:id) { 'server_security_misconfiguration.using_default_credentials.production_server' }

      it 'returns a formatted lineage string' do
        expect(sample_map.get_lineage(id)).to eq(
          'Server Security Misconfiguration (1.1) > Using Default Credentials > Production Server'
        )
      end

      context 'when specifying max depth' do
        it 'returns a formatted lineage string with the correct max depth' do
          expect(sample_map.get_lineage(id, max_depth: 'subcategory')).to eq(
            'Server Security Misconfiguration (1.1) > Using Default Credentials'
          )
        end

        it 'returns a formatted lineage string with the correct max depth' do
          expect(sample_map.get_lineage(id, max_depth: 'category')).to eq(
            'Server Security Misconfiguration (1.1)'
          )
        end
      end
    end

    context 'with a single-level element' do
      let(:id) { 'insecure_direct_object_references_idor' }

      it 'returns a formatted lineage string' do
        expect(sample_map.get_lineage(id)).to eq 'Insecure Direct Object References (IDOR)'
      end
    end
  end

  describe '#valid?' do
    subject { sample_map.valid?(string) }

    context 'when uppercase characters' do
      let(:string) { 'server_Security_misconfiguration' }

      it { is_expected.to be_falsey }
    end

    context 'with all lowercase' do
      let(:string) { 'server_security_misconfiguration' }

      it { is_expected.to be_truthy }
    end

    context 'with invalid string' do
      let(:string) { '12112asdas2312dcdwsdf-^?' }

      it { is_expected.to be_falsey }
    end

    context 'when ending in a .' do
      let(:string) { 'server_security_misconfiguration.' }

      it { is_expected.to be_falsey }
    end

    context 'when a nested node' do
      let(:string) { 'server_security_misconfiguration.unsafe_cross_origin_resource_sharing' }
      it { is_expected.to be_truthy }
    end

    context 'when an invalid nested node' do
      let(:string) { 'server_security_misconfiguration.meep_meep_meep' }
      it { is_expected.to be_falsey }
    end

    context 'when contains numbers' do
      let(:string) { 'sensitive_data_exposure.token_leakage_via_referer.untrusted_3rd_party' }
      it { is_expected.to be_truthy }
    end
  end
end
