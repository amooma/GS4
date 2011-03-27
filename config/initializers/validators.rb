ActiveRecord::Base.class_eval do
  
  def self.validate_hostname_or_ip( *attr_names )
    # Validate the server. This is the "host" rule from RFC 3261
    # (but the patterns for IPv4 and IPv6 addresses have been fixed here).
    configuration = {
      :allow_nil   => false,
      :allow_blank => false,
      :with =>
    /^
      (?:
        (?:
          (?:
            (?:
              [A-Za-z0-9] |
              [A-Za-z0-9] [A-Za-z0-9\-]* [A-Za-z0-9]
            )
            \.
          )*
          (?:
            [A-Za-z] |
            [A-Za-z] [A-Za-z0-9\-]* [A-Za-z0-9]
          )
          \.?
        )
        |
        (?:
          (?: 25[0-5] | 2[0-4]\d | 1\d\d | [1-9]?\d )
          (?: \. (?: 25[0-5] | 2[0-4]\d | 1\d\d | [1-9]?\d ) ){3}
        )
        |
        (
          (
            ( [0-9A-Fa-f]{1,4} [:] ){7} ( [0-9A-Fa-f]{1,4} | [:] )
          )|
          (
            ( [0-9A-Fa-f]{1,4} [:] ){6}
            (
              [:] [0-9A-Fa-f]{1,4} |
              (
                ( 25[0-5] | 2[0-4]\d | 1\d\d | [1-9]?\d )
                ( \. ( 25[0-5] | 2[0-4]\d | 1\d\d | [1-9]?\d ) ){3}
              ) | [:]
            )
          )|
          (
            ( [0-9A-Fa-f]{1,4} [:] ){5}
              (
                (
                  ( [:] [0-9A-Fa-f]{1,4} ){1,2}
                )|
                [:](
                  ( 25[0-5] | 2[0-4]\d | 1\d\d | [1-9]?\d )
                  ( \. ( 25[0-5] | 2[0-4]\d | 1\d\d | [1-9]?\d ) ){3}
                )|
                [:]
              )
          )|
          (
            ( [0-9A-Fa-f]{1,4} [:] ){4}
            (
              ( ( [:] [0-9A-Fa-f]{1,4} ){1,3} ) |
              (
                ( [:] [0-9A-Fa-f]{1,4} )? [:]
                (
                  ( 25[0-5] | 2[0-4]\d | 1\d\d | [1-9]?\d )
                  ( \. ( 25[0-5] | 2[0-4]\d | 1\d\d | [1-9]?\d ) ){3}
                )
              ) | [:]
            )
          )|
          (
            ( [0-9A-Fa-f]{1,4} [:] ){3}
            (
              ( ( [:] [0-9A-Fa-f]{1,4} ){1,4} ) |
              (
                ( [:] [0-9A-Fa-f]{1,4} ){0,2} [:]
                (
                  ( 25[0-5] | 2[0-4]\d | 1\d\d | [1-9]?\d )
                  ( \. ( 25[0-5] | 2[0-4]\d | 1\d\d | [1-9]?\d ) ){3}
                )
              ) | [:]
            )
          )|
          (
            ( [0-9A-Fa-f]{1,4} [:] ){2}
            (
              ( ( [:] [0-9A-Fa-f]{1,4} ){1,5} ) |
              (
                ( [:] [0-9A-Fa-f]{1,4} ){0,3} [:]
                (
                  ( 25[0-5] | 2[0-4]\d | 1\d\d | [1-9]?\d )
                  ( \. ( 25[0-5] | 2[0-4]\d | 1\d\d | [1-9]?\d ) ){3}
                )
              ) | [:]
            )
          )|
          (
            ( [0-9A-Fa-f]{1,4} [:] ){1}
            (
              ( ( [:] [0-9A-Fa-f]{1,4} ){1,6} ) |
              (
                ( [:] [0-9A-Fa-f]{1,4} ){0,4} [:]
                (
                  ( 25[0-5] | 2[0-4]\d | 1\d\d | [1-9]?\d )
                  ( \. ( 25[0-5] | 2[0-4]\d | 1\d\d | [1-9]?\d ) ){3}
                )
              ) | [:]
            )
          )|
          (
            [:]
            (
              ( ( [:] [0-9A-Fa-f]{1,4} ){1,7} ) |
              (
                ( [:] [0-9A-Fa-f]{1,4} ){0,5} [:]
                (
                  ( 25[0-5] | 2[0-4]\d | 1\d\d | [1-9]?\d )
                  ( \. ( 25[0-5] | 2[0-4]\d | 1\d\d | [1-9]?\d ) ){3}
                )
              ) | [:]
            )
          )
        )
      )
    $/x
    }
    configuration.update( attr_names.pop ) if attr_names.last.is_a?(Hash)
    validates_format_of( attr_names, configuration )
  end
  
  # Validate username. This is the "user" rule from RFC 3261.
  def self.validate_username( attr_name )
    validates_format_of [ attr_name ], :with =>
      /^
        (?:
          (?:
            [A-Za-z0-9] |
            [\-_.!~*'()]
          ) |
          %[0-9A-F]{2} |
          [&=+$,;?\/]
        ){1,255}
      $/x, :allow_nil => false, :allow_blank => false
  end
  
  def self.validate_password(attr_name)
   validates_format_of [ attr_name ], :with =>
  /^
   (?:
   (?:
   [A-Za-z0-9] |
   [\-_.!~*'()]
        ) |
        %[0-9A-F]{2} |
        [&=+$,]
      ){0,255}
    $/x, :allow_nil => true, :allow_blank => true 
  end
  
end
