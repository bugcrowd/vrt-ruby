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
