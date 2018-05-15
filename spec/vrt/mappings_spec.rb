require 'spec_helper'

describe VRT::Mapping do
  let(:vrt) { VRT }
  let(:cvss) { described_class.new(:cvss_v3) }

  describe '#get' do
    subject { cvss.get(id_list, version) }

    context 'when cvss_v3 on leaf node' do
      let(:id_list) { %i[unvalidated_redirects_and_forwards open_redirect get_based] }
      let(:version) { '2.0' }

      it { is_expected.to eq('j') }
    end

    context 'when cvss_v3 on internal node' do
      let(:id_list) { %i[server_security_misconfiguration unsafe_cross_origin_resource_sharing critical_impact] }
      let(:version) { '2.0' }

      it { is_expected.to eq('b') }
    end

    context 'when cvss_v3 on root node with children' do
      let(:id_list) { %i[server_security_misconfiguration unsafe_file_upload no_antivirus] }
      let(:version) { '2.0' }

      it { is_expected.to eq('a') }
    end

    context 'when cvss_v3 on root node without children' do
      let(:id_list) { %i[insecure_data_storage] }
      let(:version) { '2.0' }

      it { is_expected.to eq('l') }
    end

    context 'when other' do
      let(:id_list) { %i[other] }
      let(:version) { '2.0' }

      it { is_expected.to eq('default') }
    end

    context 'when newer version' do
      let(:id_list) { %i[unvalidated_redirects_and_forwards open_redirect get_based] }
      let(:version) { '999.999' }

      it { is_expected.to eq('AV:N/AC:L/PR:L/UI:R/S:U/C:N/I:L/A:N') }
    end

    context 'when version predates the mapping' do
      context 'but id still exists' do
        let(:id_list) { %i[server_security_misconfiguration misconfigured_dns] }
        let(:version) { '1.0' }

        it 'gets the mapping from earliest version with mapping' do
          is_expected.to eq('e')
        end
      end

      context 'and id is deprecated' do
        let(:id_list) { %i[unvalidated_redirects_and_forwards open_redirect get_based_authenticated] }
        let(:version) { '1.0' }

        it 'follows deprecated_node_mapping' do
          is_expected.to eq('j')
        end
      end

      context 'and id is deprecated with valid parent' do
        let(:id_list) { %i[broken_authentication_and_session_management authentication_bypass horizontal] }
        let(:version) { '1.0' }

        it 'finds valid parent' do
          is_expected.to eq('m')
        end
      end

      context 'mapping with two keys' do
        let(:advice) { described_class.new(:remediation_advice) }
        let(:version) { '999.999' }

        subject { advice.get(id_list, version) }

        context 'when only one of the keys has values' do
          let(:id_list) { %i[server_security_misconfiguration] }

          it 'returns a hash with both mapping keys present' do
            is_expected.to match a_hash_including(
              remediation_advice: nil,
              references: [
                'https://www.owasp.org/index.php/Top_10_2013-A5-Security_Misconfiguration',
                'http://projects.webappsec.org/w/page/13246959/Server%20Misconfiguration'
              ]
            )
          end
        end

        context 'when both of the keys have values' do
          let(:id_list) { %i[server_security_misconfiguration unsafe_cross_origin_resource_sharing] }

          it 'returns a hash with both mapping keys and values present' do
            is_expected.to match a_hash_including(
              remediation_advice: 'This is advice',
              references: [
                'https://www.owasp.org/index.php/HTML5_Security_Cheat_Sheet#Cross_Origin_Resource_Sharing',
                'https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS',
                'https://www.owasp.org/index.php/Top_10_2013-A5-Security_Misconfiguration',
                'http://projects.webappsec.org/w/page/13246959/Server%20Misconfiguration'
              ]
            )
          end
        end

        context 'with arrays as the mapping values' do
          let(:id_list) { %i[server_security_misconfiguration misconfigured_dns subdomain_takeover] }

          it 'merges the arrays in order of variant -> subcategory -> category' do
            is_expected.to match a_hash_including(
              references: [
                'https://labs.detectify.com/2014/10/21/hostile-subdomain-takeover-using-herokugithubdesk-more/',
                'https://www.owasp.org/index.php/Top_10_2013-A5-Security_Misconfiguration',
                'http://projects.webappsec.org/w/page/13246959/Server%20Misconfiguration'
              ]
            )
          end
        end
      end

      context 'with arrays as the mapping values' do
        subject { described_class.new(:cwe).get(id_list, version) }
        let(:version) { '999.999' }

        context 'when mapping has a default' do
          let(:id_list) { %i[server_security_misconfiguration] }

          it 'does NOT include the default mapping value' do
            is_expected.to contain_exactly('CWE-933')
          end

          context 'no mapping exists' do
            let(:id_list) { %i[other] }

            it 'only includes the default mapping value' do
              is_expected.to contain_exactly('CWE-2000')
            end
          end
        end
      end
    end
  end
end
