module SessionsHelper


    def login(jwt_user_id)
      session[:user_id] = jwt_user_id

    end

    def log_out_session
      session.delete(:user_id)
    end
    
    def is_logged_in?
        !session[:user_id].blank?
    end


end