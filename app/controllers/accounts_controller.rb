class AccountsController < ApplicationController
  before_action :set_account, only: %i[show edit update destroy]
  before_action :authenticate_user!

  # GET /accounts
  def index
    @accounts = Account.where(connection_id: params[:connection_id])
  end

  # GET /accounts/1
  def show; end

  # GET /accounts/new
  def new
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit; end

  # POST /accounts
  def create
    @account = Account.new(account_params)

    if @account.save
      redirect_to @account, notice: 'Account was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /accounts/1
  def update
    if @account.update(account_params)
      p 'Account updated'
      # redirect_to @account, notice: 'Account was successfully updated.'
    else
      p 'NO account UPDATE'
    end
  end

  # DELETE /accounts/1
  def destroy
    @account.destroy
    redirect_to accounts_url, notice: 'Account was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_account
    @account = Account.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def account_params
    params.require(:account).permit(:account_id, :name, :nature, :ballance, :curency_code, :connection_id,
                                    :client_name)
  end
end
