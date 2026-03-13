# frozen_string_literal: true

require "nerd_dice/shared_examples/the_refresh_seed_method"

RSpec.describe NerdDice, ".refresh_seed!" do
  before do
    described_class.instance_variable_set(
      :@count_since_last_refresh,
      RefreshSeedHelper::COUNT_SINCE_LAST_REFRESH
    )
  end

  context "with no arguments" do
    describe "securerandom" do
      let(:args) { [:securerandom, nil, nil] }

      it_behaves_like "a properly refreshed seed" do
        let(:config_vars) { args }
      end
      it_behaves_like "a nil return technique" do
        let(:config_vars) { args }
      end
    end

    describe "random_rand" do
      let(:args) { [:random_rand, nil, { random_rand_prior_seed: RefreshSeedHelper::ORIGINAL_RANDOM_RAND_SEED }] }

      it_behaves_like "a properly refreshed seed" do
        let(:config_vars) { args }
      end
      it_behaves_like "a non-nil return technique" do
        let(:config_vars) { args }
      end
      it_behaves_like "an expected return value" do
        let(:config_vars) { args }
      end
    end

    describe "random_object" do
      let(:args) { [:random_object, nil, { random_object_prior_seed: RefreshSeedHelper::ORIGINAL_RANDOM_OBJECT_SEED }] }

      it_behaves_like "a properly refreshed seed" do
        let(:config_vars) { args }
      end
      it_behaves_like "a non-nil return technique" do
        let(:config_vars) { args }
      end
      it_behaves_like "an expected return value" do
        let(:config_vars) { args }
      end
    end

    describe "randomized" do
      let(:args) do
        [:randomized, nil, {
          random_rand_prior_seed: RefreshSeedHelper::ORIGINAL_RANDOM_RAND_SEED,
          random_object_prior_seed: RefreshSeedHelper::ORIGINAL_RANDOM_OBJECT_SEED
        }]
      end

      it_behaves_like "a properly refreshed seed" do
        let(:config_vars) { args }
      end
      it_behaves_like "a non-nil return technique" do
        let(:config_vars) { args }
      end
      it_behaves_like "an expected return value" do
        let(:config_vars) { args }
      end
    end
  end

  context "with seed argument(s) supplied" do
    describe "securerandom" do
      let(:args) { [:securerandom, { securerandom_seed: 400 }, nil] }

      it_behaves_like "a properly refreshed seed" do
        let(:config_vars) { args }
      end
      it_behaves_like "a nil return technique" do
        let(:config_vars) { args }
      end
    end

    describe "random_rand" do
      let(:args) do
        [:random_rand,
         { random_rand_seed: RefreshSeedHelper::NEW_RANDOM_RAND_SEED },
         { random_rand_prior_seed: RefreshSeedHelper::ORIGINAL_RANDOM_RAND_SEED }]
      end

      it_behaves_like "a properly refreshed seed" do
        let(:config_vars) { args }
      end
      it_behaves_like "a non-nil return technique" do
        let(:config_vars) { args }
      end
      it_behaves_like "an expected return value" do
        let(:config_vars) { args }
      end
      it_behaves_like "a specified random_rand seed" do
        let(:config_vars) { args }
      end
    end

    describe "random_object" do
      let(:args) do
        [:random_object,
         { random_object_seed: RefreshSeedHelper::NEW_RANDOM_OBJECT_SEED },
         { random_object_prior_seed: RefreshSeedHelper::ORIGINAL_RANDOM_OBJECT_SEED }]
      end

      it_behaves_like "a properly refreshed seed" do
        let(:config_vars) { args }
      end
      it_behaves_like "a non-nil return technique" do
        let(:config_vars) { args }
      end
      it_behaves_like "an expected return value" do
        let(:config_vars) { args }
      end
      it_behaves_like "a specified random_object seed" do
        let(:config_vars) { args }
      end
    end

    describe "randomized" do
      let(:args) do
        [:randomized,
         { random_rand_seed: RefreshSeedHelper::NEW_RANDOM_RAND_SEED,
           random_object_seed: RefreshSeedHelper::NEW_RANDOM_OBJECT_SEED },
         {
           random_rand_prior_seed: RefreshSeedHelper::ORIGINAL_RANDOM_RAND_SEED,
           random_object_prior_seed: RefreshSeedHelper::ORIGINAL_RANDOM_OBJECT_SEED
         }]
      end

      it_behaves_like "a properly refreshed seed" do
        let(:config_vars) { args }
      end
      it_behaves_like "a non-nil return technique" do
        let(:config_vars) { args }
      end
      it_behaves_like "an expected return value" do
        let(:config_vars) { args }
      end
      it_behaves_like "a specified random_rand seed" do
        let(:config_vars) { args }
      end
      it_behaves_like "a specified random_object seed" do
        let(:config_vars) { args }
      end
    end
  end

  context "with randomization techniques supplied" do
    describe "securerandom" do
      let(:args) { [:randomized, { randomization_technique: :securerandom }, nil] }

      it_behaves_like "a properly refreshed seed" do
        let(:config_vars) { args }
      end
      it_behaves_like "a nil return technique" do
        let(:config_vars) { args }
      end
      it_behaves_like "a specified randomization technique" do
        let(:config_vars) { args }
      end
    end

    describe "random_rand" do
      let(:args) do
        [:securerandom,
         { randomization_technique: :random_rand },
         { random_rand_prior_seed: RefreshSeedHelper::ORIGINAL_RANDOM_RAND_SEED }]
      end

      it_behaves_like "a properly refreshed seed" do
        let(:config_vars) { args }
      end
      it_behaves_like "a non-nil return technique" do
        let(:config_vars) { args }
      end
      it_behaves_like "an expected return value" do
        let(:config_vars) { args }
      end
      it_behaves_like "a specified randomization technique" do
        let(:config_vars) { args }
      end
    end

    describe "random_object" do
      let(:args) do
        [:securerandom,
         { randomization_technique: :random_object },
         { random_object_prior_seed: RefreshSeedHelper::ORIGINAL_RANDOM_OBJECT_SEED }]
      end

      it_behaves_like "a properly refreshed seed" do
        let(:config_vars) { args }
      end
      it_behaves_like "a non-nil return technique" do
        let(:config_vars) { args }
      end
      it_behaves_like "an expected return value" do
        let(:config_vars) { args }
      end
      it_behaves_like "a specified randomization technique" do
        let(:config_vars) { args }
      end
    end

    describe "randomized" do
      let(:args) do
        [:securerandom,
         { randomization_technique: :randomized },
         {
           random_rand_prior_seed: RefreshSeedHelper::ORIGINAL_RANDOM_RAND_SEED,
           random_object_prior_seed: RefreshSeedHelper::ORIGINAL_RANDOM_OBJECT_SEED
         }]
      end

      it_behaves_like "a properly refreshed seed" do
        let(:config_vars) { args }
      end
      it_behaves_like "a non-nil return technique" do
        let(:config_vars) { args }
      end
      it_behaves_like "an expected return value" do
        let(:config_vars) { args }
      end
      it_behaves_like "a specified randomization technique" do
        let(:config_vars) { args }
      end
    end
  end

  context "with all options specified" do
    let(:args) do
      [:securerandom,
       { randomization_technique: :randomized,
         random_rand_seed: RefreshSeedHelper::NEW_RANDOM_RAND_SEED,
         random_object_seed: RefreshSeedHelper::NEW_RANDOM_OBJECT_SEED },
       {
         random_rand_prior_seed: RefreshSeedHelper::ORIGINAL_RANDOM_RAND_SEED,
         random_object_prior_seed: RefreshSeedHelper::ORIGINAL_RANDOM_OBJECT_SEED
       }]
    end

    it_behaves_like "a properly refreshed seed" do
      let(:config_vars) { args }
    end
    it_behaves_like "a non-nil return technique" do
      let(:config_vars) { args }
    end
    it_behaves_like "an expected return value" do
      let(:config_vars) { args }
    end
    it_behaves_like "a specified random_rand seed" do
      let(:config_vars) { args }
    end
    it_behaves_like "a specified random_object seed" do
      let(:config_vars) { args }
    end
    it_behaves_like "a specified randomization technique" do
      let(:config_vars) { args }
    end
  end
end
