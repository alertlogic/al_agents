actions     :install

attribute   :name, :kind_of => String, :name_attribute => true, :required => true
attribute   :vsn, :kind_of => Hash, :required => true
attribute   :base_url, :kind_of => String, :required => true
attribute   :arch, :kind_of => String, :equal_to => ["x86_64", "i386"]
attribute   :controller_host, :kind_of => String
attribute   :inst_type, :kind_of => String, :equal_to => ["host", "role", ""]
attribute   :provision_key, :kind_of => String, :required => true
