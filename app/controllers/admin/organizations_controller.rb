module Admin
  class OrganizationsController < Admin::BaseController
    load_and_authorize_resource except: [:update_multiple]

    def index
      @organizations = Organization.includes(:users).title_sorted.paginate(page: params[:page])
    end

    def new
      @organization = Organization.new
    end

    def create
      @organization = Organization.new(organization_params)
      @organization.build_inventory
      @organization.build_catalog
      if @organization.save
        flash[:notice] = I18n.t('flash.notice.organization.create')
        redirect_to admin_organizations_path
      else
        # flash[:alert] = I18n.t('flash.alert.organization.create')
        render 'new'
      end
      
    end

    def edit
      @organization = Organization.friendly.find(params[:id])
      @title = @organization.title
      @organization.build_administrator unless @organization.administrator
      @organization.build_liaison unless @organization.liaison
    end

    def update
      @organization = Organization.find(params[:id])
      @title = @organization.title
      if @organization.update(organization_params)
        flash[:notice] = I18n.t('flash.notice.organization.update')

        unless @title == params[:title]
          ShogunHarvestWorker.updateorg(@title, params[:title])
        end
        redirect_to admin_organizations_path
      else
        # flash[:alert] = I18n.t('flash.alert.organization.update')
        render 'edit'
      end
    end

    def edit_multiple
      @organizations = Organization.title_sorted
    end

    def update_multiple
      authorize! :update, Organization
      @success = Organization.update(params[:organizations].keys, params[:organizations].values)
    end

    private

    def organization_params
      params.require(:organization).permit(
        :title,
        :description,
        :landing_page,
        :gov_type,
        :ranked,
        :ministry,
        administrator_attributes: [:user_id],
        liaison_attributes: [:user_id],
        organization_sectors_attributes: [:id, :sector_id, :_destroy])
    end
  end
end
