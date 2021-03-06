describe Moneta::Api::Service do
  let(:params) { { demo_mode: true } }
  let(:service) { described_class.new($username, $password, params) }

  describe '#find_account_by_id', vcr: true do
    subject { service.find_account_by_id(account_id) }

    context 'when success response' do
      let(:account_id) { 10999 }

      its('account.id') { is_expected.to eq '10999' }
    end

    context 'when soap raise error' do
      let(:account_id) { -1 }

      it { expect { subject }.to raise_exception(Moneta::Api::RuntimeException, '(SOAP-ENV:Client) Validation error') }
    end
  end

  describe 'wsdl url' do
    subject{ service.client.globals.instance_variable_get('@options')[:wsdl] }

    context 'when demo mode' do
      it { is_expected.to eq 'https://demo.moneta.ru/services.wsdl' }
    end

    context 'when demo mode' do
      let(:params) { {} }

      it { is_expected.to eq 'https://www.moneta.ru/services.wsdl' }
    end
  end

  describe 'request validate' do
    it { expect { service.authorise_transaction('invalid request') }.to raise_exception(TypeError, "String can't be coerced into Moneta::Api::Requests::AuthoriseTransactionRequest") }
  end
end
