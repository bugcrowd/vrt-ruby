require 'spec_helper'

describe VRT::ThirdPartyLinks do
  let(:vrt) { VRT }

  describe '#get' do
    subject(:get_mapping) { described_class.new(scheme, directory: directory).get(id_list, version) }

    let(:id_list) { %i[server_security_misconfiguration directory_listing_enabled sensitive_data_exposure] }
    let(:directory) { nil }
    let(:scheme) { 'secure-code-warrior-links' }
    let(:version) { '999.999' }

    context 'when mapping is nested under a subdirectory' do
      let(:directory) { 'remediation_training' }
      let(:version) { '2.0' }

      it 'gives the third party link for the id_list' do
        expect(subject).to eq('https://integration-api.securecodewarrior.com/api/v1/trial?id=bugcrowd&mappingList=vrt&mappingKey=server_security_misconfiguration:directory_listing_enabled:sensitive_data_exposure&redirect=true')
      end
    end

    context 'when mapping is under a flat directory' do
      it 'gives the third party link for the id_list' do
        expect(subject).to eq('https://integration-api.securecodewarrior.com/api/v1/trial?id=bugcrowd&mappingList=vrt&mappingKey=server_security_misconfiguration:directory_listing_enabled:sensitive_data_exposure&redirect=true')
      end
    end

    context 'for invalid scheme' do
      let(:scheme) { :not_a_valid_mapping }

      it 'fails to find the mapping' do
        expect { get_mapping }.to raise_error VRT::Errors::MappingNotFound
      end
    end

    context 'if the id_list is invalid' do
      let(:id_list) { %i[server_security_misconfiguration complete_gibbrish] }

      it 'returns nil' do
        expect(get_mapping).to be_nil
      end
    end
  end
end
