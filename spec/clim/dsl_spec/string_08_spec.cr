require "../dsl_spec"

{% begin %}
{%
  main_help_message = <<-HELP_MESSAGE

                        Command Line Interface Tool.

                        Usage:

                          main_command_of_clim_library [options] [arguments]

                        Options:

                          -s ARG, --string=ARG             String option description. [type:String] [default:"default value"]
                          --help                           Show this help.


                      HELP_MESSAGE
%}

spec(
  spec_class_name: MainCommandWithStringRequiredFalseAndDefaultExists,
  spec_dsl_lines: [
    "option \"-s ARG\", \"--string=ARG\", type: String, desc: \"String option description.\", required: false, default: \"default value\"",
  ],
  spec_desc: "main command with String options,",
  spec_cases: [
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => String,
        "method" => "string",
        "expect_value" => "default value",
      },
      expect_args: [] of String,
    },
    {
      argv:        ["arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => String,
        "method" => "string",
        "expect_value" => "default value",
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["-s", "string1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => String,
        "method" => "string",
        "expect_value" => "string1",
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-sstring1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => String,
        "method" => "string",
        "expect_value" => "string1",
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--string", "string1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => String,
        "method" => "string",
        "expect_value" => "string1",
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--string=string1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => String,
        "method" => "string",
        "expect_value" => "string1",
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-s", "string1", "arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => String,
        "method" => "string",
        "expect_value" => "string1",
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "-s", "string1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => String,
        "method" => "string",
        "expect_value" => "string1",
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["-string"], # Unintended case.
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => String,
        "method" => "string",
        "expect_value" => "tring",
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-s=string1"], # Unintended case.
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => String,
        "method" => "string",
        "expect_value" => "=string1",
      },
      expect_args: [] of String,
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
      argv:              ["-s"],
      exception_message: "Option that requires an argument. \"-s\"",
    },
    {
      argv:              ["--string"],
      exception_message: "Option that requires an argument. \"--string\"",
    },
    {
      argv:              ["arg1", "-s"],
      exception_message: "Option that requires an argument. \"-s\"",
    },
    {
      argv:              ["arg1", "--string"],
      exception_message: "Option that requires an argument. \"--string\"",
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
  ]
)
{% end %}
