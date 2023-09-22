# MIL4planning


A planning problem can be viewed as a
Meta-interpretive learning: application to grammatical inference 
https://link.springer.com/article/10.1007/s10994-013-5358-3
 
The idea is to analyze plans from PDDL  planners and learn a grammar. You may ignore attributes at first. It is kind of feasibility study, only preliminary experiments. 
The overall motivation is to explore whether MIL could help to learn the Domain Control Knowledge  Attributed Transition-Based Domain Control Knowledge for Domain-Independent Planning https://ieeexplore.ieee.org/document/9253709


## Project proposal

The input consists of two directories: positive examples and negative examples.

An example is a plan in the form as in entry_files/sample_plans.zip/all-domains/hiking-translated .

The output is a regular grammar that generates/accepts all positive examples and none negative example.

The core algorithm should be implemented in SWI_Prolog as a MIL program suited to add heuristics used in louise program (or similar).

The program may call some loise procedures but it should check the correctness of the output ($louise$ does not do it properly).
The user interface should allow to rename some invented predicates (like $1).

## Theoretical guidelines  (too broad, I know)

The overall motivation is to explore whether Meta-interpretative learning (MIL) could help to learn the Domain Control Knowledge (DCK) for planning domains.
The student should study the current state of the MIL - meta learning of logic programs. The MIL system Louise allows to learn a simple regular or context free grammar.
The student should use a set of plans for a specific planning domain as a set of positive examples for MIL learning. Resulting grammar may be too general or too specific domain knowledge. The student should whether negative examples and suitable meta-rule specifications can lead to a useful DCK. The student should explore several planning domains, for example domains used in [1].

## References

[1] L. Chrpa, R. Barták, J. Vodrážka and M. Vomlelová, "Attributed Transition-Based Domain Control Knowledge for Domain-Independent Planning," in IEEE Transactions on Knowledge and Data Engineering, vol. 34, no. 9, pp. 4089-4101, 1 Sept. 2022, doi: 10.1109/TKDE.2020.3037058.

S. Patsantzis and S. H. Muggleton. Meta-Interpretive Learning as Metarule Specialisation. Machine Learning, 2021
S. Patsantzis and S. H. Muggleton. Top Program Construction and Reduction for Polynomial-Time Meta-interpretive Learning. Machine Learning, 2021
S.H. Muggleton, D. Lin, N. Pahlavi, and A. Tamaddoni-Nezhad. Meta-interpretive learning: application to grammatical inference. Machine Learning, 94:25-49, 2014

GitHub - stassa/louise: Polynomial-time Meta-Interpretive Learning: https://github.com/stassa/louise












## Getting started in GitLab

To make it easy for you to get started with GitLab, here's a list of recommended next steps.

Already a pro? Just edit this README.md and make it your own. Want to make it easy? [Use the template at the bottom](#editing-this-readme)!

## Add your files

- [ ] [Create](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#create-a-file) or [upload](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#upload-a-file) files
- [ ] [Add files using the command line](https://docs.gitlab.com/ee/gitlab-basics/add-file.html#add-a-file-using-the-command-line) or push an existing Git repository with the following command:

```
cd existing_repo
git remote add origin https://gitlab.mff.cuni.cz/teaching/nprg045/vomlelova/mil4planning.git
git branch -M master
git push -uf origin master
```

## Integrate with your tools

- [ ] [Set up project integrations](https://gitlab.mff.cuni.cz/teaching/nprg045/vomlelova/mil4planning/-/settings/integrations)

## Collaborate with your team

- [ ] [Invite team members and collaborators](https://docs.gitlab.com/ee/user/project/members/)
- [ ] [Create a new merge request](https://docs.gitlab.com/ee/user/project/merge_requests/creating_merge_requests.html)
- [ ] [Automatically close issues from merge requests](https://docs.gitlab.com/ee/user/project/issues/managing_issues.html#closing-issues-automatically)
- [ ] [Enable merge request approvals](https://docs.gitlab.com/ee/user/project/merge_requests/approvals/)
- [ ] [Automatically merge when pipeline succeeds](https://docs.gitlab.com/ee/user/project/merge_requests/merge_when_pipeline_succeeds.html)

## Test and Deploy

Use the built-in continuous integration in GitLab.

- [ ] [Get started with GitLab CI/CD](https://docs.gitlab.com/ee/ci/quick_start/index.html)
- [ ] [Analyze your code for known vulnerabilities with Static Application Security Testing(SAST)](https://docs.gitlab.com/ee/user/application_security/sast/)
- [ ] [Deploy to Kubernetes, Amazon EC2, or Amazon ECS using Auto Deploy](https://docs.gitlab.com/ee/topics/autodevops/requirements.html)
- [ ] [Use pull-based deployments for improved Kubernetes management](https://docs.gitlab.com/ee/user/clusters/agent/)
- [ ] [Set up protected environments](https://docs.gitlab.com/ee/ci/environments/protected_environments.html)

***

# Editing this README

When you're ready to make this README your own, just edit this file and use the handy template below (or feel free to structure it however you want - this is just a starting point!). Thank you to [makeareadme.com](https://www.makeareadme.com/) for this template.

## Suggestions for a good README
Every project is different, so consider which of these sections apply to yours. The sections used in the template are suggestions for most open source projects. Also keep in mind that while a README can be too long and detailed, too long is better than too short. If you think your README is too long, consider utilizing another form of documentation rather than cutting out information.

## Name
Choose a self-explaining name for your project.

## Description
Let people know what your project can do specifically. Provide context and add a link to any reference visitors might be unfamiliar with. A list of Features or a Background subsection can also be added here. If there are alternatives to your project, this is a good place to list differentiating factors.

## Badges
On some READMEs, you may see small images that convey metadata, such as whether or not all the tests are passing for the project. You can use Shields to add some to your README. Many services also have instructions for adding a badge.

## Visuals
Depending on what you are making, it can be a good idea to include screenshots or even a video (you'll frequently see GIFs rather than actual videos). Tools like ttygif can help, but check out Asciinema for a more sophisticated method.

## Installation
Within a particular ecosystem, there may be a common way of installing things, such as using Yarn, NuGet, or Homebrew. However, consider the possibility that whoever is reading your README is a novice and would like more guidance. Listing specific steps helps remove ambiguity and gets people to using your project as quickly as possible. If it only runs in a specific context like a particular programming language version or operating system or has dependencies that have to be installed manually, also add a Requirements subsection.

## Usage
Use examples liberally, and show the expected output if you can. It's helpful to have inline the smallest example of usage that you can demonstrate, while providing links to more sophisticated examples if they are too long to reasonably include in the README.

## Support
Tell people where they can go to for help. It can be any combination of an issue tracker, a chat room, an email address, etc.

## Roadmap
If you have ideas for releases in the future, it is a good idea to list them in the README.

## Contributing
State if you are open to contributions and what your requirements are for accepting them.

For people who want to make changes to your project, it's helpful to have some documentation on how to get started. Perhaps there is a script that they should run or some environment variables that they need to set. Make these steps explicit. These instructions could also be useful to your future self.

You can also document commands to lint the code or run tests. These steps help to ensure high code quality and reduce the likelihood that the changes inadvertently break something. Having instructions for running tests is especially helpful if it requires external setup, such as starting a Selenium server for testing in a browser.

## Authors and acknowledgment
Show your appreciation to those who have contributed to the project.

## License
For open source projects, say how it is licensed.

## Project status
If you have run out of energy or time for your project, put a note at the top of the README saying that development has slowed down or stopped completely. Someone may choose to fork your project or volunteer to step in as a maintainer or owner, allowing your project to keep going. You can also make an explicit request for maintainers.
