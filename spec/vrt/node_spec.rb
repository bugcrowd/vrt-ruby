require 'spec_helper'

describe VRT::Node do
  describe '#children?' do
    subject(:has_children) { VRT::Map.new(version).find_node(id).children? }

    let(:version) { '2.0' }

    context 'when node has children' do
      let(:id) { 'server_security_misconfiguration.unsafe_cross_origin_resource_sharing' }

      it { is_expected.to be true }
    end

    context 'when node does not have children' do
      let(:id) { 'server_security_misconfiguration.unsafe_cross_origin_resource_sharing.high_impact' }

      it { is_expected.to be false }
    end
  end

  describe 'children' do
    subject(:children) { VRT::Map.new(version).find_node(id).children }

    let(:version) { '2.0' }

    context 'when node has children' do
      let(:id) { 'server_security_misconfiguration.unsafe_cross_origin_resource_sharing' }

      it 'should contain a list of child nodes' do
        expect(children.length).to eq 2
      end
    end

    context 'when node does not have children' do
      let(:id) { 'server_security_misconfiguration.unsafe_cross_origin_resource_sharing.high_impact' }

      it { is_expected.to be_empty }
    end
  end

  describe '#mappings' do
    subject(:mappings) { VRT::Map.new(version).find_node(id).mappings }

    let(:version) { '2.0' }
    let(:id) { 'server_security_misconfiguration.unsafe_cross_origin_resource_sharing.high_impact' }

    it 'returns a hash with the correct keys' do
      expect(mappings.keys).to eq(VRT::MAPPINGS)
    end

    context 'cvss_v3' do
      it 'has the right values' do
        expect(mappings).to include(cvss_v3: 'b')
      end
    end

    context 'remediation_advice' do
      let(:id) { 'server_security_misconfiguration.unsafe_cross_origin_resource_sharing' }

      it 'has the expected remediation advice' do
        expect(mappings[:remediation_advice]).to match hash_including(
          remediation_advice: 'This is advice'
        )
      end

      it 'has the expected (concatenated) references' do
        expect(mappings[:remediation_advice]).to match hash_including(
          references: [
            'https://www.owasp.org/index.php/HTML5_Security_Cheat_Sheet#Cross_Origin_Resource_Sharing',
            'https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS',
            'https://www.owasp.org/index.php/Top_10_2013-A5-Security_Misconfiguration',
            'http://projects.webappsec.org/w/page/13246959/Server%20Misconfiguration'
          ]
        )
      end
    end

    context 'cwe' do
      it 'has the exepected (concatenated) CWE IDs' do
        expect(mappings[:cwe]).to eq %w[
          CWE-942
          CWE-933
        ]
      end
    end
  end

  describe '#third_party_links' do
    subject(:third_party_links) { VRT::Map.new(version).find_node(id).third_party_links }

    let(:version) { '2.0' }
    let(:id) { 'server_security_misconfiguration.unsafe_cross_origin_resource_sharing' }

    it { is_expected.to include(:scw) }

    it 'loads correct mapping' do
      expect(third_party_links[:scw]).to eq 'https://integration-api.securecodewarrior.com/api/v1/trial?id=bugcrowd&mappingList=vrt&mappingKey=server_security_misconfiguration:unsafe_cross_origin_resource_sharing&redirect=true'
    end
  end

  describe '#as_json' do
    subject(:node_hash) { VRT::Map.new(version).find_node(id).as_json }

    let(:version) { '2.0' }

    context 'when node is a parent' do
      let(:id) { 'server_security_misconfiguration' }

      it 'should return nil parent id' do
        expect(node_hash['parent']).to be_nil
        expect(node_hash['qualified_vrt_id']).to eq id
        expect(node_hash['children'].length).to eq 9
      end
    end

    context 'when node is a leaf' do
      let(:id) { 'unvalidated_redirects_and_forwards.open_redirect.get_based' }

      it 'should return the full parent id and no children' do
        expect(node_hash['parent']).to eq 'unvalidated_redirects_and_forwards.open_redirect'
        expect(node_hash['children']).to be_empty
        expect(node_hash['has_children']).to be_falsey
        expect(node_hash['qualified_vrt_id']).to eq id
      end
    end
  end
end
