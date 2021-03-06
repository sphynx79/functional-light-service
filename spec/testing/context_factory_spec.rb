require "spec_helper"
require "test_doubles"

describe "ContextFactory - used with AdditionOrganizer" do
  let(:organizer) { TestDoubles::AdditionOrganizer }

  context "when called with the first action" do
    it "does not alter the context" do
      ctx = FunctionalLightService::Testing::ContextFactory
            .make_from(organizer)
            .for(TestDoubles::AddsOneAction)
            .with(1)

      expect(ctx[:number]).to eq(1)
    end
  end

  context "when called with the second action" do
    it "adds one to the number provided" do
      ctx = FunctionalLightService::Testing::ContextFactory
            .make_from(organizer)
            .for(TestDoubles::AddsTwoAction)
            .with(1)

      expect(ctx.number).to eq(2)
    end
  end

  context "when called with third action" do
    it "creates a context up-to the action defined" do
      ctx = FunctionalLightService::Testing::ContextFactory
            .make_from(organizer)
            .for(TestDoubles::AddsThreeAction)
            .with(1)

      expect(ctx.number).to eq(4)
    end
  end

  context "when there are already before_actions" do
    it "only appends before_actions" do
      TestDoubles::AdditionOrganizer.before_actions = [
        ->(ctx) { ctx[:number] += 1 if ctx.current_action == TestDoubles::AddsTwoAction }
      ]

      context = FunctionalLightService::Testing::ContextFactory
                .make_from(TestDoubles::AdditionOrganizer)
                .for(TestDoubles::AddsThreeAction)
                .with(4) # Context is a "glorified" hash

      expect(context.number).to eq(8)
      expect(context[:_before_actions].length).to eq(1)
    end
  end
end
