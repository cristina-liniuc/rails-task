class ConnectionsController < ApplicationController
  before_action :set_connection, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  APP_ID = "Sdl8BesDB4qCTnKf2jiez2BFb_D5w8XFZ1mAEeffmNs"
  SECRET = "-L-Co75UGHSVixmeHxKB700bKqPCt1zIw3Ofr0qaSPM"
  # GET /connections
  def index
    @connections = current_user.connections
  end

  # GET /connections/1
  def show
  end


  #GET /connections/fetch_data
  def fetch_connections

    #request to fetch connections
    begin
      response = RestClient::Request.execute(method: :get, 
                                          url: "https://www.saltedge.com/api/v5/connections?customer_id=#{current_user.customer_id}",
                                          headers: {"Accept" => "application/json",
                                                    "Content-Type" => "application/json",
                                                    "App-id" => APP_ID,
                                                    "Secret" => SECRET}
                                          )
      rescue RestClient::ExceptionWithResponse => e
      e.response
    end

    @connection_list = ActiveSupport::JSON.decode(response.body)['data']

    @connection_list.each do |connection_item|
      next if Connection.exists?(connection_id: connection_item['id'].to_i)
      @connection = Connection.new(customer_id: current_user.customer_id, connection_id: connection_item['id'].to_i, provider_code: connection_item['provider_code'], provider_name: connection_item['provider_name'])
      if @connection.save
        p 'Connection was successfully created.'
      else
        p 'NO CONNECTION.'
      end
    end

    #request to fetch accounts
    current_user.connections.each do |element|
      begin
        response = RestClient::Request.execute(method: :get, 
                                            url: "https://www.saltedge.com/api/v5/accounts?connection_id=#{element[:connection_id]}",
                                            headers: {"Accept" => "application/json",
                                                      "Content-Type" => "application/json",
                                                      "App-id" => APP_ID,
                                                      "Secret" => SECRET}
                                            )
        rescue RestClient::ExceptionWithResponse => e
        e.response
      end 

      @accounts_list = ActiveSupport::JSON.decode(response.body)['data']
      @accounts_list.each do |account_item|
        #find_by or initialize
        if Account.exists?(account_id: account_item['id'].to_i)
          @account = Account.find_by(account_id: account_item['id'].to_i)
          @account.update(account_id: account_item['id'].to_i, 
                            name: account_item['name'], 
                            nature: account_item['nature'], 
                            ballance: account_item['balance'].to_f, 
                            curency_code: account_item['currency_code'], 
                            connection_id: account_item['connection_id'], 
                            client_name: account_item['extra']['client_name'])
        else @account = Account.new(account_id: account_item['id'].to_i, 
                               name: account_item['name'], 
                               nature: account_item['nature'], 
                               ballance: account_item['balance'].to_f, 
                               curency_code: account_item['currency_code'], 
                               connection_id: account_item['connection_id'], 
                               client_name: account_item['extra']['client_name'])
          if @account.save!
            p 'Account was successfully created.'
          else
            p 'NO account.'
          end
        end
      end
    end

    #fetch for transactions
    current_user.connections.each do |connection|
      connection.accounts.each do |element|
        begin
          response = RestClient::Request.execute(method: :get, 
                                              url: "https://www.saltedge.com/api/v5/transactions?connection_id=#{element[:connection_id]}&account_id=#{element[:account_id]}",
                                              headers: {"Accept" => "application/json",
                                                        "Content-Type" => "application/json",
                                                        "App-id" => APP_ID,
                                                        "Secret" => SECRET}
                                              )
          rescue RestClient::ExceptionWithResponse => e
          e.response
        end 

        @transactions_list = ActiveSupport::JSON.decode(response.body)['data']
        @transactions_list.each do |transaction_item|
          next if Transaction.exists?(transaction_id: transaction_item['id'].to_i)
          @transaction = Transaction.new(transaction_id: transaction_item['id'].to_i, 
                                         mode: transaction_item['mode'], 
                                         status: transaction_item['status'], 
                                         made_on: transaction_item['made_on'].to_time, 
                                         amount: transaction_item['amount'].to_f, 
                                         currency_code: transaction_item['currency_code'], 
                                         description: transaction_item['description'],
                                         category: transaction_item['category'],
                                         account_id: transaction_item['account_id'],
                                         origiinal_amount: transaction_item['extra']['original_amount'].to_f,
                                         original_currency_code: transaction_item['extra']['original_currency_code'])
          if @transaction.save
            p 'transaction was successfully created.'
          else
            p 'NO Transaction.'
          end
        end
      end
    end

    redirect_to action: 'index'    
  end

  # GET /connections/new
  def new
    # @connection = Connection.new
    begin
      response = RestClient::Request.execute(method: :post, 
                                          url: 'https://www.saltedge.com/api/v5/connect_sessions/create',
                                          payload: {"data" => {"customer_id" => "#{current_user.customer_id}",
                                                               "return_connection_id" => false,
                                                               "consent" => {"scopes" => ["account_details", "transactions_details"]},
                                                               "attempt" => {"return_to" => "http://localhost:3000/connections/fetch_connections"}}}.to_json,
                                          headers: {"Accept" => "application/json",
                                                    "Content-Type" => "application/json",
                                                    "App-id" => APP_ID,
                                                    "Secret" => SECRET}
                                          )
      rescue RestClient::ExceptionWithResponse => e
      e.response
    end
    @connect_url = ActiveSupport::JSON.decode(response.body)['data']['connect_url']
    redirect_to @connect_url
  end

  # GET /connections/1/edit
  def edit
  end

  # POST /connections
  def create
    @connection = Connection.new(connection_params)

    if @connection.save
      redirect_to @connection, notice: 'Connection was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /connections/1
  def update
    if @connection.update(connection_params)
      redirect_to @connection, notice: 'Connection was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /connections/1
  def destroy
    @connection.destroy
    redirect_to connections_url, notice: 'Connection was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_connection
      @connection = Connection.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def connection_params
      params.require(:connection).permit(:customer_id, :connection_id, :provider_code, :provider_name)
    end
end
