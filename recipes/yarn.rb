
# 
# Creating symbolic links from spark jars in the lib/ directory where spark is installed to 
# the directory containing yarn jars in hadoop. Hopefully, yarn will pick up these jars and add them
# to the HADOOP_CLASSPATH :)
# One potential problem could be if you install spark as a different user than the default user 'yarn'.
# Then the symbolic link may not be able to be created due to a lack of file privileges.
# 
jars = ["datanucleus-api-jdo-3.2.6.jar",  "datanucleus-core-3.2.10.jar",  "datanucleus-rdbms-3.2.9.jar",  "spark-#{node[:spark][:version]}-yarn-shuffle.jar",  "spark-assembly-#{node[:spark][:version]}-hadoop#{node[:hadoop][:version]}.jar"]

#,  "spark-examples-#{node[:spark][:version]}-hadoop#{node[:hadoop][:version]}.jar"]


for jar in jars
  
  jar.gsub! "-#{node[:spark][:version]}" ""
  jar.gsub! "-#{node[:hadoop][:version]}" ""

  file "#{node[:hadoop][:home]}/share/hadoop/yarn/#{jar}" do
    owner node[:hadoop][:yarn][:user]
    group node[:hadoop][:group]
    action :delete
  end

  link "#{node[:hadoop][:home]}/share/hadoop/yarn/#{jar}" do
    owner node[:hadoop][:yarn][:user]
    group node[:hadoop][:group]
    to "#{node[:spark][:home]}/lib/#{jar}"
  end
end
