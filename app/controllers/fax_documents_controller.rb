class FaxDocumentsController < ApplicationController
  
  before_filter :authenticate_user!, :unless => Proc.new { |r| r.request.remote_ip   == '127.0.0.1' }

  skip_authorization_check

  before_filter { |controller|
    @users = User.accessible_by( current_ability, :index ).all
  }
  
  # GET /fax_documents
  # GET /fax_documents.xml
  def index
    @fax_documents = FaxDocument.accessible_by( current_ability, :index ).all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @fax_documents }
    end
  end

  # GET /fax_documents/1
  # GET /fax_documents/1.xml
  def show
    @fax_document = FaxDocument.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @fax_document }
      format.tif {
        raw_file_suffix = File.basename(Configuration.get(:fax_file_suffix, '.tif'))
        raw_file =  File.expand_path("#{Configuration.get(:fax_files_directory)}/#{@fax_document.raw_file}#{raw_file_suffix}")
        send_file raw_file, :type => "image/tiff", 
          :filename => File.basename(@fax_document.file, File.extname(@fax_document.file)) + raw_file_suffix
      }
      format.png {
        thumbnail_suffix = File.basename(Configuration.get(:fax_thumbnail_suffix, '.png'))
        thumbnail_file = File.expand_path("#{Configuration.get(:fax_files_directory)}/#{@fax_document.raw_file}#{thumbnail_suffix}")
        send_file thumbnail_file, :type => "image/png", :disposition => 'inline', 
          :filename => File.basename(@fax_document.file, File.extname(@fax_document.file)) + thumbnail_suffix
      }
    end
  end

  # GET /fax_documents/new
  # GET /fax_documents/new.xml
  def new
    @fax_document = FaxDocument.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @fax_document }
    end
  end

  # GET /fax_documents/1/edit
  def edit
    @fax_document = FaxDocument.find(params[:id])
    @edit_document = true
  end

  # POST /fax_documents
  # POST /fax_documents.xml
  def create
    @fax_document = FaxDocument.new(params[:fax_document])
    #@fax_document.save_file(params[:fax_document])
    
    respond_to do |format|
      if  @fax_document.save
        format.html { redirect_to(@fax_document, :notice => t(:fax_document_created)) }
        format.xml  { render :xml => @fax_document, :status => :created, :location => @fax_document }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @fax_document.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /fax_documents/1
  # PUT /fax_documents/1.xml
  def update
    @fax_document = FaxDocument.find(params[:id])
    
    respond_to do |format|
      if @fax_document.update_attributes(params[:fax_document])
        format.html { redirect_to(@fax_document, :notice => t(:fax_document_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @fax_document.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /fax_documents/1
  # DELETE /fax_documents/1.xml
  def destroy
    @fax_document = FaxDocument.find(params[:id])
    @fax_document.destroy
    
    respond_to do |format|
      format.html { redirect_to(fax_documents_url) }
      format.xml  { head :ok }
    end
  end
  
  def confirm_destroy
    @fax_document = FaxDocument.find(params[:id])
  end
  
end
