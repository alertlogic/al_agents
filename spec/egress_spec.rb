require 'spec_helper'
class Chef
  # namespaced to Chef::Recipe
  class Recipe
    describe 'Egress' do
      # context 'unit testing' do
      #   let(:egress) { double('egress') }
      #
      #   before do
      #     allow(Egress).to receive(:new).and_return(egress)
      #     allow(Egress).to receive(:host)
      #   end
      #
      #   it 'test' do
      #     expect(Egress).to receive(:host)
      #   end
      # end

      context '.host' do
        context 'with scheme' do
          let(:egress_scheme) { 'https://' }
          let(:egress_host) { 'vaporator.alertlogic.com' }
          let(:egress_port) { '443' }
          let(:egress_url) { "#{egress_scheme}#{egress_host}:#{egress_port}" }
          let(:node) { Hash['al_agent' => { 'agent' => { 'egress_url' => egress_url } }] }
          let(:egress) { Egress.new(node) }
          it 'returns vaporator.alertlogic.com' do
            expect(egress.host).to eql(egress_host)
            expect(egress.port).to eql(egress_port.to_i)
          end
        end

        context 'without scheme' do
          let(:egress_scheme) { '' }
          let(:egress_host) { 'noscheme.alertlogics.com' }
          let(:egress_port) { '443' }
          let(:egress_url) { "#{egress_host}:#{egress_port}" }
          let(:node) { Hash['al_agent' => { 'agent' => { 'egress_url' => egress_url } }] }
          let(:egress) { Egress.new(node) }
          it 'returns vaporator.alertlogic.com' do
            expect(egress.host).to eql(egress_host)
            expect(egress.port).to eql(egress_port.to_i)
          end
        end
      end
    end
  end
end
