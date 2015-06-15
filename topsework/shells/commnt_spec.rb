# -*- coding: utf-8 -*-

require_relative 'spec_helper'

describe Webapi::Models::Comment do
    it "create a new comment." do
        comment = Webapi::Models::Comment.create(:display_name => "spec test",
                                                 :comment => "test comment")
        expect(comment).to eq(Webapi::Models::Comment[comment.id])
    end

    # it "validation display_name size must be 10 or less." do
    #    expect { Webapi::Models::Comment.create(:display_name => "spec test 2",
    #                                            :comment => "test comment.") }.to raise_error(Sequel::ValidationFailed)
    # end
end
