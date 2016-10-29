Instructions
============

1. Please answer the following question using Ruby, JavaScript or Java without using any third party gems, plugins, or jar files with the exception of  test frameworks (i.e. MiniTest, RSpec, Mocha/Chai, JUnit, etc).

1. Treat this problem as a library. No UI or file/console input is expected or required.

1. Add a Readme file that at least includes:
    - runtime versions (e.g. Ruby 2.3)
    - how to install any dependencies
    - how to run your tests from the command line

1. Many commits. Don't squash into a single commit.

1. Please submit via publicly accessible repo so that we can review your commits.

1. Note: if you choose to submit a Java solution either include the config files for Eclipse or IntelliJ and/or include a build script written using Ant, Maven, or Gradle so we can easily build your solution and run your tests.

Pricing problem
===============

NuPack is responsible for taking existing products and repackaging them for sale at electronic stores like Best Buy. Companies will phone up NuPack, explain the process and NuPack needs to quickly give them an estimate of how much it will cost. Different markups to the job:

* Without exception, there is a flat markup on all jobs of 5%
* For each person that needs to work on the job, there is a markup of 1.2%

Markups are also added depending on the types of materials involved:

* If pharmaceuticals are involved, there is an immediate 7.5% markup
* For food, there is a 13% markup
* Electronics require a 2% markup
* Everything else, there is no markup

Another system calculates the base price depending on how many products need to be repackaged. As such, the markup calculator should accept the initial base price along with the different categories of markups and calculate a final cost for a project.

The flat markup is calculated first and then all other markups are calculated on top of the base price plus flat markup.

Example 1:
----------

    Input:  $1,299.99, 3 people, food
    Output: $1,591.58

Example 2:
----------

    Input:  $5,432.00, 1 person, drugs
    Output: $6,199.81

Example 3:
----------

    Input:  $12,456.95, 4 people, books
    Output: $13,707.63
