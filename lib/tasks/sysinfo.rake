namespace :sysinfo do
  task :get => :environment do
    diskfree_data  = `/bin/df /opt/gemeinschaft-local/db | grep db | awk '{print $5}`
    diskfree_db    = `/bin/df /opt/gemeinschaft-local/data | grep data | awk '{print $5}`
    load_avg = `cat /proc/loadavg | awk '{print $3}'`
    mem_total  = `free | grep Mem | awk '{print $2}'`
    mem_free   = `free | grep Mem | awk '{print $3}'`
    memory_free = (mem_free.to_f/(mem_total.to_f/100))
    
    SystemInfo.create(
      :diskfree_data => diskfree_data.to_i,
      :diskfree_db => diskfree_db.to_i,
      :load_avg => load_avg.to_f,
      :memory_free => memory_free.to_i
    )
    
  end
end


# Local Variables:
# mode: ruby
# End:

