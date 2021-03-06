require "../dsl_spec"

{% begin %}
{%
  main_help_message = <<-HELP_MESSAGE

                      Command Line Interface Tool.

                      Usage:

                        main_command_of_clim_library [options] [arguments]

                      Options:

                        --help                           Show this help.

                      Sub Commands:

                        sub_command   Sub command with desc.


                    HELP_MESSAGE

  sub_help_message = <<-HELP_MESSAGE

                     Sub command with desc.

                     Usage:

                       sub_command with usage [options] [arguments]

                     Options:

                       --help                           Show this help.


                   HELP_MESSAGE
%}

spec(
  spec_class_name: SubCommandWithDescAndUsage,
  spec_sub_command_lines: [
    <<-SUB_COMMAND,
    sub "sub_command" do
      desc "Sub command with desc."
      usage "sub_command with usage [options] [arguments]"
      run do |options, arguments|
      end
    end
    SUB_COMMAND
  ],
  spec_desc: "option type spec,",
  spec_cases: [
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_args: [] of String,
    },
    {
      argv:        ["arg1"],
      expect_help: {{main_help_message}},
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "arg2"],
      expect_help: {{main_help_message}},
      expect_args: ["arg1", "arg2"],
    },
    {
      argv:        ["arg1", "arg2", "arg3"],
      expect_help: {{main_help_message}},
      expect_args: ["arg1", "arg2", "arg3"],
    },
    {
      argv:              ["-h"],
      exception_message: "Undefined option. \"-h\"",
    },
    {
      argv:              ["--help", "-ignore-option"],
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              ["-ignore-option", "--help"],
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:        ["--help"],
      expect_help: {{main_help_message}},
    },
    {
      argv:        ["--help", "ignore-arg"],
      expect_help: {{main_help_message}},
    },
    {
      argv:        ["ignore-arg", "--help"],
      expect_help: {{main_help_message}},
    },
    {
      argv:        ["sub_command"],
      expect_help: {{sub_help_message}},
      expect_args: [] of String,
    },
    {
      argv:        ["sub_command", "arg1"],
      expect_help: {{sub_help_message}},
      expect_args: ["arg1"],
    },
    {
      argv:        ["sub_command", "arg1", "arg2"],
      expect_help: {{sub_help_message}},
      expect_args: ["arg1", "arg2"],
    },
    {
      argv:        ["sub_command", "arg1", "arg2", "arg3"],
      expect_help: {{sub_help_message}},
      expect_args: ["arg1", "arg2", "arg3"],
    },
    {
      argv:              ["sub_command", "--help", "-ignore-option"],
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              ["sub_command", "-ignore-option", "--help"],
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              ["sub_command", "-m"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["sub_command", "--missing-option"],
      exception_message: "Undefined option. \"--missing-option\"",
    },
    {
      argv:              ["sub_command", "-m", "arg1"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["sub_command", "arg1", "-m"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["sub_command", "-m", "-d"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:        ["sub_command", "--help"],
      expect_help: {{sub_help_message}},
    },
    {
      argv:        ["sub_command", "--help", "ignore-arg"],
      expect_help: {{sub_help_message}},
    },
    {
      argv:        ["sub_command", "ignore-arg", "--help"],
      expect_help: {{sub_help_message}},
    },
  ]
)
{% end %}

macro spec_for_sub_sub_commands(spec_class_name, spec_cases)
  {% for spec_case, index in spec_cases %}
    {% class_name = (spec_class_name.stringify + index.stringify).id %}

    # define dsl
    class {{class_name}} < Clim
      main_command do
        run do |opts, args|
          assert_opts_and_args({{spec_case}})
        end
        sub "sub_command" do
          run do |opts, args|
            assert_opts_and_args({{spec_case}})
          end
          sub "sub_sub_command" do
            run do |opts, args|
              assert_opts_and_args({{spec_case}})
            end
          end
        end
      end
    end

    # spec
    describe "sub sub command," do
      describe "if argv is " + {{spec_case["argv"].stringify}} + "," do
        it_blocks({{class_name}}, {{spec_case}})
      end
    end
  {% end %}
end
