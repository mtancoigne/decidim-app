Files under 94% coverage:

| Checked | File                                                                   | % covered | Lines | Relevant lines | Covered |  Missed | Avg hit/line |
|--------:|------------------------------------------------------------------------|----------:|------:|---------------:|--------:|--------:|-------------:|
| ignored | ~~`lib/tasks/import.rake`~~                                            |    3.77 % |   226 |            106 |       4 | ~~102~~ |         0.04 |
| deleted | ~~`app/jobs/decidim/machine_translation_resource_job.rb`~~             |   18.52 % |   120 |             54 |      10 |  ~~44~~ |         0.19 |
|  split? | `lib/tasks/migrate.rake`                                               |   25.66 % |   234 |            113 |      29 |      84 |         0.26 |
|    !ctx | `app/services/decidim/s3_sync_service.rb`                              |   32.00 % |   113 |             50 |      16 |    _34_ |         0.32 |
|   !hard | `lib/extends/controllers/decidim/devise/account_controller_extends.rb` |   35.00 % |    37 |             20 |       7 |    _13_ |         0.35 |
|    !ctx | `app/services/decidim/s3_retention_service.rb`                         |   38.24 % |    79 |             34 |      13 |    _21_ |         0.38 |
|    100% | `lib/tasks/repair_data.rake`                                           |   58.54 % |    73 |             41 |      24 |  ~~17~~ |         0.83 |
|    100% | `lib/tasks/db.rake`                                                    |   73.91 % |    41 |             23 |      17 |   ~~6~~ |         0.74 |
| deleted | ~~`lib/active_storage/downloadable.rb`~~                               |   75.00 % |     9 |              4 |       3 |   ~~1~~ |         0.75 |
|    100% | `app/helpers/decidim/backup_helper.rb`                                 |   75.00 % |    13 |              4 |       3 |   ~~1~~ |         0.75 |
|    100% | `app/services/decidim/action_log_service.rb`                           |   76.92 % |    30 |             13 |      10 |   ~~3~~ |         1.15 |
|    100% | `lib/decidim/translator_configuration_helper.rb`                       |   77.78 % |    19 |              9 |       7 |   ~~2~~ |         0.89 |
|    100% | `lib/decidim_app/sentry_setup.rb`                                      |   80.00 % |    55 |             30 |      24 |   ~~6~~ |         5.83 |
|       - | `app/services/dummy_authorization_handler.rb`                          |   84.62 % |   107 |             26 |      22 |     _4_ |         2.50 |
|    100% | `lib/decidim/rspec_runner.rb`                                          |   87.50 % |    63 |             32 |      28 |   ~~4~~ |         2.31 |
|    100% | `lib/decidim_app/decidim_initiatives.rb`                               |   93.18 % |    81 |             44 |      41 |   ~~3~~ |         1.32 |
|    100% | `app/services/decidim/database_service.rb`                             |   93.33 % |    55 |             30 |      28 |   ~~2~~ |         2.50 |
|    100% | `lib/tasks/decidim_app.rake`                                           |   93.55 % |    75 |             31 |      29 |   ~~2~~ |         0.94 |

- `lib/tasks/import.rake`
  - Ignored for now : it looks like the task _should not succeed_ in its current state
- `lib/active_storage/downloadable.rb`
  - Module is badly included in an attempt to override the default `ActiveStorage::Blob`'s `open` method, in `config/application.rb`:
    ```rb
    ActiveStorage::Blob.instance_method(:open).source_location
    # => ["/<path>/activestorage-6.1.7.6/app/models/active_storage/blob.rb", 275]
    ActiveStorage::Blob.ancestors
    # => [ActiveStorage::Blob(Table doesn't exist), #<Module:0x000055619537a130>, ActiveStorage::Blob::Representable, ...]
    # Downloadable is not yet loaded
    
    ActiveStorage::Blob.include ActiveStorage::Downloadable
    ActiveStorage::Blob.instance_method(:open).source_location
    # => ["/<path>/activestorage-6.1.7.6/app/models/active_storage/blob.rb", 275]
    # It is still the original method.
    ActiveStorage::Blob.ancestors
    # => [ActiveStorage::Blob(Table doesn't exist), ActiveStorage::Downloadable, #<Module:0x000055619537a130>, ActiveStorage::Blob::Representable, ...]
    # "Downloadable" is _before_ the Blob class; "open()" is not overriden as declared _before_ the original one.
    
    # With "prepend" instead of "include"
    ActiveStorage::Blob.prepend ActiveStorage::Downloadable
    ActiveStorage::Blob.instance_method(:open).source_location
    # => ["/<path>/decidim-app/lib/active_storage/downloadable.rb", 5]
    ActiveStorage::Blob.ancestors
    # => [ActiveStorage::Downloadable, ActiveStorage::Blob, ...]
    ```
    That being said, using the right method leads to the test suite to fail. Both file and inclusion were removed from project.
- `app/jobs/decidim/machine_translation_resource_job.rb`
  - Duplicate file from decidim-core (`decidim-core/app/jobs/decidim/machine_translation_resource_job.rb`), tested in `decidim-core/spec/jobs/decidim/machine_translation_resource_job_spec.rb`. File was removed from the project.
- `lib/tasks/migrate.rake`
  - Classes extracted from task, then tested
  - There is still has a lot of procedural code which _should_ be extracted to other files (`RailsMigrations`, maybe)
  - Task itself was not tested
- `lib/extends/controllers/decidim/devise/account_controller_extends.rb`
  - I don't figure _how_ to get in the right context right now
- `app/services/decidim/s3_sync_service.rb`
  - `#file_list` output _may_ be inconsistent: when a file list empty, the list is created from the backup directory and files are prefixed with the directory name. If the file list is given, no prefix is added.
    Tests were written to ensure this behavior, but still, it _feels_ weird to me somehow.
- `app/services/decidim/s3_retention_service.rb`
  - `#retention_dates` Could be tested better with [timecop](https://github.com/travisjeffery/timecop) gem to have reproducible results
  - **Incomplete:** `#execute` needs proper context and is not yet tested
  - Duplicated code with `s3_sync_service.rb`. I treated the files as if they were totally different ones (copy-pasted the common tests). A rework of the code of these two classes may be a good idea, with no duplicated tests too.
    I could have made some shared examples, but I prefer not to yet, as I don't know if the classes _should_ be treated as totally independent.
- `lib/tasks/repair_data.rake`
- `app/helpers/decidim/backup_helper.rb`
  **Question:** What should be the behavior when outside a git repository ? Proposed test replacement:
  ```rb
  describe "#generate_subfolder_name" do
    context "without a Git repository" do
      it "raises an exception" do # instead of it "returns an incomplete string"
        FileUtils.cd File.dirname(temp_dir) do
          expect do
            generate_subfolder_name
          end.to raise_error
        end
      end
    end
  end
  ```
- `app/services/dummy_authorization_handler.rb`
  - This seems to be unused outside of tests.  No additional test written.
- `lib/tasks/decidim_app.rake`
  - `decidim_app:setup` is explicitly ignored. Left as-is.
  - Tests checks that tasks don't fail; underlying code is already tested

## Notes

SimpleCov's reports are broken : files tested individually have a 100% coverage but have a lower percentage when running 
the whole suite. Attempts to fix:

- Load SimpleCove earlier in the test suite: sometime better, still inconsistent
- Enable `config.eager_load` in `test` environment when SimpleCov is active: 
  - Run 1 : `1654 relevant lines, 1255 lines covered and 399 lines missed. ( 75.88% )`

**Too much time spent on this, I will continue to write missing test from one coverage report of reference.** Possible matrix to help fix this:

|  Early activation of Codecov  |  eager loading  | result                  |
|:-----------------------------:|:---------------:|:------------------------|
|               N               |        N        | consistent/inconsistent |
|               Y               |        N        | consistent/inconsistent |
|               N               |        Y        | consistent/inconsistent |
|               Y               |        Y        | consistent/inconsistent |

Each combination should be run twice with `SIMPLECOV=1`; and `coverage.json` should be diffed.

---

Some tests fail randomly. No attempts to fix this is made but the failing tests are logged below:

```text
rspec ./spec/lib/tasks/decidim_app/k8s/install_task_spec.rb:10 # rake decidim_app:k8s:install calls db:migrate
rspec ./spec/lib/tasks/decidim_app/k8s/external_install_or_reload_task_spec.rb:12 # rake decidim_app:k8s:external_install_or_reload calls the manager service
rspec ./spec/lib/tasks/decidim_app/k8s/upgrade_task_spec.rb:10 # rake decidim_app:k8s:upgrade calls db:migrate
---
rspec ./spec/lib/tasks/decidim_app/k8s/install_task_spec.rb:10 # rake decidim_app:k8s:install calls db:migrate
rspec ./spec/lib/tasks/decidim_app/k8s/external_install_or_reload_task_spec.rb:12 # rake decidim_app:k8s:external_install_or_reload calls the manager service
rspec ./spec/services/decidim/repair_translations_service_spec.rb:12 # Decidim::RepairTranslationsService#translatable_resources returns all translatable resources
---
rspec ./spec/lib/decidim_app/rack_attack_spec.rb:74 # DecidimApp::RackAttack#apply_configuration Throttling successful for 100 requests, then blocks the user
rspec ./spec/lib/tasks/decidim_app/k8s/external_install_or_reload_task_spec.rb:12 # rake decidim_app:k8s:external_install_or_reload calls the manager service
rspec ./spec/services/decidim/repair_translations_service_spec.rb:12 # Decidim::RepairTranslationsService#translatable_resources returns all translatable resources
rspec ./spec/lib/tasks/decidim_app/k8s/upgrade_task_spec.rb:10 # rake decidim_app:k8s:upgrade calls db:migrate
rspec ./spec/lib/tasks/decidim_app/k8s/install_task_spec.rb:10 # rake decidim_app:k8s:install calls db:migrate
---
rspec ./spec/lib/decidim_app/rack_attack_spec.rb:74 # DecidimApp::RackAttack#apply_configuration Throttling successful for 100 requests, then blocks the user
rspec ./spec/services/decidim/repair_translations_service_spec.rb:12 # Decidim::RepairTranslationsService#translatable_resources returns all translatable resources
---
rspec ./spec/services/decidim/repair_translations_service_spec.rb:12 # Decidim::RepairTranslationsService#translatable_resources returns all translatable resources
rspec ./spec/lib/tasks/decidim_app/k8s/upgrade_task_spec.rb:10 # rake decidim_app:k8s:upgrade calls db:migrate
Faker random seed: 235210546495071501042241816473778476976
Randomized with seed 118
```

This may come from state leaking between tests ; an attempt to fix this would be to replay the suite with the same seeds (both RSpec and Faker), see if the same tests fails.
A possible helping gem to get started: [rspec-retry](https://github.com/NoRedInk/rspec-retry) will retry failing tests, helping to sort out flaky ones.

---

A lot of debug information is thrown during tests. Some of them may be fixable:

```log
2023-10-24 09:15:28 +0200 SEVERE: http://26.lvh.me:6493/packs-test/js/vendors-node_modules_rails_activestorage_app_assets_javascripts_activestorage_js-node_modules-03f302.js 21284:2 Uncaught Error: Map container not found.
```

---

A lot of the code coverage comes from indirect tests. It may be a good idea to check if it's the case for critical files of the project, and write additional specific tests.
Gems of interest to help in that task: [rspec-specification-coverage](https://github.com/pr0d1r2/rspec-specification-coverage) (never tested, interesting behavior)

---

`app/services/*_dummy_*` may be ignored

---

`#service`, `#initialize`, `.run`, and`#subfolder` methods duplicated in 
  - `app/services/decidim/s3_sync_service.rb`
  - `app/services/decidim/s3_retention_service.rb`
Maybe move the methods in a parent class or a module?

Also, the `#default_options` method in these files have a lot in common. Maybe the config from `Rails.application.config.backup.dig(:s3sync, *)` could be extracted in a common `s3_default_options`?

---

Running RSpec with the `documentation` formatter results in a mix of the default formatter and the documentation one:
```sh
bundle exec rspec spec/services/decidim/s3_sync_service_spec.rb --format documentation
```

---

Note on memoization :

```rb
def value
  @value ||= something_incredibly_costly
end
```

If, for any reason `something_incredibly_costly` returns `nil` or `false`, it will be re-run on next `value()` call.

To prevent this edge case, check when possible, for definition of the instance variable:

```rb
def value
  return @value if instance_variable_defined? :@value
  
  @value = something_incredibly_costly
end
```
