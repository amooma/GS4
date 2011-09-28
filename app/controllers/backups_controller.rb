class BackupsController < ApplicationController
 skip_authorization_check
	# Allow access from 127.0.0.1 and [::1] only.
	prepend_before_filter { |controller|
		if ! request.local?
			if user_signed_in? && current_user.role == "admin"
				logger.info( "[FS] Request from #{request.remote_addr.inspect} is not local but the user is an admin ..." )
			else
				logger.info( "[FS] Denying non-local request from #{request.remote_addr.inspect} ..." )
				render :status => '403 None of your business',
					:layout => false, :content_type => 'text/plain',
					:text => "<!-- This is none of your business. -->"
			end
		end
	}
  # GET /backups
  # GET /backups.xml
  def index
    @backups = Backup.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @backups }
    end
  end

  # GET /backups/1
  # GET /backups/1.xml
  def show
    @backup = Backup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @backup }
    end
  end

  # GET /backups/new
  # GET /backups/new.xml
  def new
    @backup = Backup.new
    @backup.state = "RUNNING"
    all_devices =`
      for i in $(ls -1d /sys/block/[sh]d? 2>/dev/null); do
        d="${i##/sys/block/}"
        c="$(cat $i/device/vendor 2>/dev/null) $(cat $i/device/model 2>/dev/null) ($(awk '{print ($1 / 2048) "MB"}' $i/size 2>/dev/null))"
        dlist="${dlist:+$dlist|}$d:$c"
      done
      echo $dlist
      `
    device_list = all_devices.split('|')
    @backup_devices = Array.new
    device_list.each { |device|
      disk = device.split(':')[0]
      mounted = `grep "/dev/#{disk}" /proc/mounts`
      if mounted.empty?
              @backup_devices << device
              
      end
      }

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @backup }
    end
  end

 

  # POST /backups
  # POST /backups.xml
  def create
    @backup = Backup.new(params[:backup])

    respond_to do |format|
      if @backup.save
        format.html { redirect_to(@backup, :notice => 'Backup was successfully created.') }
        format.xml  { render :xml => @backup, :status => :created, :location => @backup }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @backup.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /backups/1
  # PUT /backups/1.xml
  def update
    @backup = Backup.find(params[:id])

    respond_to do |format|
      if @backup.update_attributes(params[:backup])
        format.xml  { head :ok }
      else
        format.xml  { render :xml => @backup.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /backups/1
  # DELETE /backups/1.xml
  def destroy
    @backup = Backup.find(params[:id])
    @backup.destroy

    respond_to do |format|
      format.html { redirect_to(backups_url) }
      format.xml  { head :ok }
    end
  end
end
