require "spec_helper"

describe MiqTemplate do
  it ".corresponding_model" do
    described_class.corresponding_model.should == Vm
    ManageIQ::Providers::Vmware::InfraManager::Template.corresponding_model.should == ManageIQ::Providers::Vmware::InfraManager::Vm
    ManageIQ::Providers::Redhat::InfraManager::Template.corresponding_model.should == ManageIQ::Providers::Redhat::InfraManager::Vm
  end

  it ".corresponding_vm_model" do
    described_class.corresponding_vm_model.should == Vm
    ManageIQ::Providers::Vmware::InfraManager::Template.corresponding_vm_model.should == ManageIQ::Providers::Vmware::InfraManager::Vm
    ManageIQ::Providers::Redhat::InfraManager::Template.corresponding_vm_model.should == ManageIQ::Providers::Redhat::InfraManager::Vm
  end

  context "#template=" do
    before(:each) { @template = FactoryGirl.create(:template_vmware) }

    it "true" do
      @template.update_attribute(:template, true)
      @template.type.should == "ManageIQ::Providers::Vmware::InfraManager::Template"
      @template.template.should == true
      @template.state.should == "never"
      -> { @template.reload }.should_not raise_error
      -> { ManageIQ::Providers::Vmware::InfraManager::Vm.find(@template.id) }.should raise_error ActiveRecord::RecordNotFound
    end

    it "false" do
      @template.update_attribute(:template, false)
      @template.type.should == "ManageIQ::Providers::Vmware::InfraManager::Vm"
      @template.template.should == false
      @template.state.should == "unknown"
      -> { @template.reload }.should raise_error ActiveRecord::RecordNotFound
      -> { ManageIQ::Providers::Vmware::InfraManager::Vm.find(@template.id) }.should_not raise_error
    end
  end

  it ".supports_kickstart_provisioning?" do
    ManageIQ::Providers::Amazon::CloudManager::Template.supports_kickstart_provisioning?.should be_false
    ManageIQ::Providers::Redhat::InfraManager::Template.supports_kickstart_provisioning?.should be_true
    ManageIQ::Providers::Vmware::InfraManager::Template.supports_kickstart_provisioning?.should be_false
  end

  it "#supports_kickstart_provisioning?" do
    ManageIQ::Providers::Amazon::CloudManager::Template.new.supports_kickstart_provisioning?.should be_false
    ManageIQ::Providers::Redhat::InfraManager::Template.new.supports_kickstart_provisioning?.should be_true
    ManageIQ::Providers::Vmware::InfraManager::Template.new.supports_kickstart_provisioning?.should be_false
  end
end
