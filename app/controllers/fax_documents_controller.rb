class FaxDocumentsController < ApplicationController
  
  before_filter :authenticate_user!

  # GET /fax_documents
  # GET /fax_documents.xml
  def index
    @fax_documents = FaxDocument.all

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
        send_file "#{FAX_FILES_DIRECTORY}/#{@fax_document.raw_file}.tif", :type => "image/tiff", 
		  :filename => File.basename(@fax_document.file, File.extname(@fax_document.file)) + '.tif'
	  }
	  format.png {
        send_file "#{FAX_FILES_DIRECTORY}/#{@fax_document.raw_file}.png", :type => "image/png", :disposition => 'inline', 
		  :filename => File.basename(@fax_document.file, File.extname(@fax_document.file)) + '.png'
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
  end

  # POST /fax_documents
  # POST /fax_documents.xml
  def create
    @fax_document = FaxDocument.new(params[:fax_document])
	@fax_document.save_file(params[:fax_document])
	
    respond_to do |format|
      if  @fax_document.save
        format.html { redirect_to(@fax_document, :notice => 'Fax document was successfully created.') }
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
        format.html { redirect_to(@fax_document, :notice => 'Fax document was successfully updated.') }
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
end
