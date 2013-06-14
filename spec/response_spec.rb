require 'spec_helper'

describe Roark::Response do
  it "should set code to 1 if not specified" do
    expect(subject.code).to eq(1)
  end

  it "should set message to '' if not specified" do
    expect(subject.message).to eq('')
  end

  it "should return true if code eq 0" do
    response = subject
    response.code = 0
    expect(response.success?).to be_true
  end

  it "should return false if code is not 0" do
    expect(subject.success?).to be_false
  end
end
