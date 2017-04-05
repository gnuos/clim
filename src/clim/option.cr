class Clim
  class Option(T)
    property short : String
    property long : String
    property default : T
    property required : Bool
    property desc : String
    property value : T
    property set_value_flag : Bool
    property set_default_flag : Bool

    def initialize(@short, @long, @default, @required, @desc, @value, @set_value_flag = false, @set_default_flag = false)
    end

    def short_name
      extract_name(short)
    end

    def long_name
      extract_name(long)
    end

    def name
      long.empty? ? short_name : long_name
    end

    def extract_name(name)
      name.split(/(\s|=)/).first.gsub(/^-*/, "")
    end

    def to_h
      {name => value}
    end

    def desc
      desc = @desc
      desc = desc + "  [default:#{default}]" unless default.to_s.empty?
      desc = desc + "  [required]" if required
      desc
    end

    def set_string(@value, @set_value_flag = true)
    end

    def set_bool(arg, @set_value_flag = true)
      if arg.empty?
        @value = true
      else
        exception_msg = "Bool arguments accept only \"true\" or \"false\". Input: [#{arg}]"
        raise ClimException.new exception_msg unless arg === "true" || arg == "false"
        @value = arg === "true"
      end
    end

    def add_to_array(arg, @set_value_flag = true)
      @value << arg
    end

    def reset(@set_value_flag = false)
      @value = @default.dup
    end

    def required?
      @required
    end

    def set_value?
      @set_value_flag
    end

    def set_default?
      @set_default_flag
    end

    def no_required_option?
      required? && !set_value?
    end

    def no_value?
      !required? && !set_default? && !set_value?
    end
  end
end
