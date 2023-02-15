# Contributing to the NerdDice Project

Thank you for visiting the NerdDice repository and for taking interest in collaborating on the project. The primary goal of this project is educational: we want to teach people how to code with [Ruby](https://www.ruby-lang.org/en/). This is a published gem on [RubyGems](https://rubygems.org/gems/nerd_dice) and can be used in other projects using the instructions outlined in the [README](README.md#installation).

<a name="before-you-start"></a>
## Before you start...
Everything in this repository is intended to be made freely available via the [UNLICENSE](UNLICENSE.txt) and the [Creative Commons](https://creativecommons.org) [CC0 Public Domain Dedication](https://creativecommons.org/publicdomain/zero/1.0/). You can obviously submit feature requests and issues and participate in the discussions, but we can\'t accept anything into this repository and project unless you agree to make it available under the terms above. See the [legal](README.md#legal) section in the README for more information.

### Coding Videos
We make [coding videos](https://youtube.com/playlist?list=PL9kkbu1kLUeOnUtMpAnJOCtHdThx1Efkt) on our [YouTube channel](https://www.youtube.com/statelesscode) for the end-to-end of this project. If you collaborate on this project, you are consenting to potentially have the interaction featured in our videos. There is no guarantee or obligation to include your contribution or interaction in our videos, and we reserve the right to moderate inappropriate content at our own discretion.

## Ways to Contribute
There are numerous ways to contribute to this project, irrespective of your level of technical expertise. We\'ll flesh out the details and guidelines for each way to contribute below

- **[Feature requests](#feature-requests)**
- **[Bug reports](#bug-reports)**
- **[Code contributions](#code-contributions)**
- **[Documentation contributions](#documentation-contributions)**
- **[Art, design and creative input](#art-design-creative-input)**

<a name="feature-requests"></a>
### Feature requests
If you have an idea for a feature you would like to see in the NerdDice gem, feel free to [open an issue](https://github.com/statelesscode/nerd_dice/issues) in this GitHub repository. As an agile project, we strive to provide value. The better you can articulate your idea and the value it would bring to you as a user of the gem or including in your own project, it will help us determine whether or how to prioritize the idea.

Once an issue is submitted, we will likely need to discuss and clarify the feature request via comments to refine and clarify the intent, scope, and value of the feature. Precisely articulating your original feature request will help reduce the back-and-forth necessary to evaluate the story for implementation.

We can\'t guarantee that your feature request will be implemented or featured in a video, but truly welcome the collaboration and feedback of all who take interest.

<a name="bug-reports"></a>
### Bug reports
The distinction between a feature and a bug can sometimes be murky. While a feature generally refers to a request for new functionality, a bug is related to existing functionality that is not working as intended. In order to better evaluate the bug for a fix, it is extremely helpful to follow the following format:
#### Expected behavior
How you as a user or a technical evaluator would expect the application to behave. Expectation is obviously subjective, but defining your expectations as a user can help to expose usability problems with the application. If you discover a bug, we warmly welcome you to [open an issue](https://github.com/statelesscode/nerd_dice/issues) in this GitHub repository unless it is a [security bug](#security-bugs) that could be exploited and is not suitable for public collaboration.

**Examples:**
- When I use the `roll_` convenience method with `plus` and `minus` I expect it to error out.
- When I configure a randomization technique I expect that the configuration will persist until I change it or stop the Ruby interpreter
- When I roll a 6-sided die, I expect to get a number between 1 and 6, inclusive

#### Actual behavior
The actual behavior is what really happens when you try to use your feature in a way that defies your expectations. Using the same examples listed above, you can see how this might work.

**Examples:**
- The method doesn't error out and uses the plus but not the minus
- The configuration always reverts the randomization technique to `:secure_random`
- I sometimes get a 0 and I never get a 6

#### Steps to reproduce
In order to properly fix the bug, it needs to be reproducible. The more detailed and precise your steps to reproduce are, the more likely it will be that we come to the right solution in fixing the bug. Sometimes a bug will only manifest if an exact sequence of events takes place. The more complex an application gets, the harder it becomes to isolate and diagnose the root cause. An example of steps to reproduce the first problem can look something like this.
- Include the gem in the `Gemfile` and run `bundle install`
- Open the `Pry` console
- Execute the following commands
```ruby
o = Object.new
o.roll_2d8.harvest_totals
```
- A `NoMethodError` is raised

In this case the `NoMethodError` is caused by improper usage of the `harvest_totals` method, but providing specifics about what you are trying to do and what you expect to have happen can result in better clarity of documentation or a new feature.

<a name="security-bugs"></a>
#### Security bugs
If you discover a security vulnerability in the application that can be exploited, please follow our [security reporting process](SECURITY.md) instead of submitting a public issue.

<a name="code-contributions"></a>
### Code contributions
At Stateless Code our motto is \"Code Along\" and we mean it. If you have a feature that you want to implement yourself and contribute to the project, or you see an item in the [project backlog](https://github.com/statelesscode/nerd_dice/projects/1) that you want to try and tackle yourself, you are encouraged to do so.
#### Open an issue, if applicable
If there's a brand new feature you want to propose, or you want to work on a backlog item that is not yet converted into an issue, you can [open an issue](https://github.com/statelesscode/nerd_dice/issues) in this GitHub repository as you would in the sections above.
#### Fork the repository
To work on your changes, you will want to [fork this repository](https://github.com/statelesscode/nerd_dice/fork) into a repo on your own account so you can work and iterate on your feature.
#### Develop the feature
After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

Once you have forked the repo, you can work to develop the contribution on your account. As you are working on your contribution you can commit as frequently as you'd like. \(We'll likely squash the commit down if and when it becomes time to merge the feature.\) In order to avoid rework, be sure to follow the [coding standards](#coding-standards) below. If the pull request is a candidate for merging, we will review the code and iterate on any feedback as needed.
<a name="coding-standards"></a>
#### Coding standards
Just like [Ruby on Rails](https://rubyonrails.org/) is able to increase programmer happiness by using convention over configuration, it\'s important to follow a consistent set of conventions throughout the code base to make it more consistent and maintainable. Some of these standards are just preferences while others \(like writing good tests\) are indispensable. If you feel strongly that one of these conventions should be modified and have good reasons to back it up, cordial conversation in an [issue](https://github.com/statelesscode/nerd_dice/issues) can be productive. I don\'t have all the answers and am constantly learning and evolving as a programmer myself. Just don\'t be a jerk about it.
##### Always cover your code with good tests!
Whenever it\'s possible and feasible, we recommend using a test-driven development approach \(red, green, refactor\) . We have a video on [Why Test Driven Development](https://youtu.be/AGXfZP-EhKo) on our [YouTube channel](https://www.youtube.com/statelesscode) if you\'d like to learn more.
- Write your failing test
- Implement your change in the application code to make the test pass
- Refactor your code

Tests should be meaningful, failing without your code and passing only with your code. And the assertions you make about your code should be meaningful. **Covering code with a test that doesn\'t make meaningful assertions is worse than not covering your code at all.**

##### Make sure the build will pass
Before your pull request can be merged, we need to make sure the GitHub Actions build will not fail. The following criteria must be met:
- `rubocop` needs to run without violations. If there is no way around a RuboCop violation, we can add disable-enable magic comments, but this should be seen as a last resort
- The test suite needs to pass. Running `rspec spec` from the root of the project will run the unit tests
- The code coverage can\'t decrease. This will cause the Coveralls check on the code to fail.
##### Avoid cognitive complexity and giant methods
One of the common mottoes in the Ruby ecosystem is Don\'t Repeat Yourself \(DRY\). You want to write small, reusable methods for your code instead of giant thousand line monstrosities with if-else ladders and nested loops with more if-else ladders. Breaking your code down into bite sized chunks makes it more maintainable and less bug prone. It also allows you to write smaller, more-targeted unit tests. \"Working, but ugly\" is a common early iteration condition of a feature, but before we merge it to the main branch, we want our end goal to be elegant, expressive, concise code.
##### Write a good commit message
When you\'re incrementally working on a story, it's fine to use the one-line `git commit -m "My commit message"` method of committing your code. When you squash it down at the end of the pull request, you want a good commit message for your contribution. There are many great resources on the internet about writing quality commit messages. [This one from cbeams](https://cbea.ms/git-commit/) is one of my favorites.
<a name="documentation-contributions"></a>
### Documentation contributions
You don\'t need to be a programmer to contribute to the project! If you have suggestions for clarity on documentation for the project \(as small as fixing a typo or as big as setting up a Wiki category\) you are welcome to contribute. If you aren\'t interested in learning about GitHub, git, or the version control process, you can still [open an issue](https://github.com/statelesscode/nerd_dice/issues) in this GitHub repository and provide your content contributions there. Of course, if you are comfortable with the pull request process from the [code contributions](#code-contributions) section, you are welcome to do so. We just don\'t want that to be a barrier to entry.

<a name="art-design-creative-input"></a>
### Art, design and creative input
If you have art, design, or other forms of creative input on the project that don\'t fit the above criteria, you can [open an issue](https://github.com/statelesscode/nerd_dice/issues) in this GitHub repository for that as well. As noted in the [Before you start...](#before-you-start) section, we can\'t accept any contributions unless you agree to match them to the repository standards of CC0 and/or the UNLICENSE.

<a name="guidelines-for-etiquette"></a>
## Guidelines for etiquette
See the [Conduct](README.md#conduct) section in the README for more information.
