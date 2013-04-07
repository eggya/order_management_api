require "spec_helper"

describe LineItemsController do
  describe "routing" do

    it "routes to #index" do
      get("/line_items").should route_to("line_items#index")
    end

    it "routes to #show" do
      get("/line_items/1").should route_to("line_items#show", :id => "1")
    end

    it "routes to #create" do
      post("/line_items").should route_to("line_items#create")
    end

    it "routes to #update" do
      put("/line_items/1").should route_to("line_items#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/line_items/1").should route_to("line_items#destroy", :id => "1")
    end

  end
end
