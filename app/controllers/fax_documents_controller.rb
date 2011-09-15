class FaxDocumentsController < ApplicationController
  
  before_filter :authenticate_user!, :unless => Proc.new { |r| r.request.remote_ip   == '127.0.0.1' }
  
  load_and_authorize_resource :except => [:create]
  skip_authorization_check :only => [:create]
  
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
      format.html 
      format.xml  { render :xml => @fax_document }
      format.tif {
        raw_file_name = @fax_document.raw_file_path
        send_file raw_file_name, :type => "image/tiff", 
          :filename => File.basename(@fax_document.file, File.extname(@fax_document.file)) + '.tif'
      }
      format.png {
        thumbnail_file_name = @fax_document.thumbnail_file_path
        if ! thumbnail_file_name
            thumbnail_file_name = @fax_document.to_thumbnail
        end
        send_file thumbnail_file_name, :type => "image/png", :disposition => 'inline', 
          :filename => File.basename(@fax_document.file, File.extname(@fax_document.file)) + '.png'
      }
      format.pdf {
        pdf_file_name = @fax_document.pdf_file_path
        if ! pdf_file_name
            pdf_file_name = @fax_document.to_pdf
        end
        send_file pdf_file_name, :type => "application/pdf", 
          :filename => File.basename(@fax_document.file, File.extname(@fax_document.file)) + '.pdf'
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
    if (! @fax_document.outgoing && ! @fax_document.user_id )
      @fax_document.user_id = destination_to_user(@fax_document.destination)
    end

    respond_to do |format|
      if  @fax_document.save
        if (Configuration.get(:fax_send_mail, true, Configuration::Boolean) && ! @fax_document.outgoing && @fax_document.user_id )
          FaxMailer.new_fax_document(@fax_document).deliver
        end
		format.html { redirect_to :action => 'number', :id => @fax_document.id }
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
  
  def number
    @fax_document = FaxDocument.find(params[:id])
  end
  
  def transfer
    @fax_document = FaxDocument.find(params[:id])
    if (params[:fax_document] && ! params[:fax_document][:destination].blank?)
      destination = params[:fax_document][:destination]
    end
    respond_to do |format|
      if @fax_document.update_attributes(:destination => destination) && @fax_document.transfer(destination)
        format.html { redirect_to(@fax_document, :notice => t(:fax_document_sending)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "number" }
        format.xml  { render :xml => @fax_document.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
  def destination_to_user(destination)
    extension = Extension.where(:extension => destination, :active => true).first
    if (! extension || ! extension.users.first)
      return nil
    end
    return extension.users.first.id
  end
end
