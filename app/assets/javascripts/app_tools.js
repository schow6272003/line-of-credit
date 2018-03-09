var appTools = {
    findAllCreditLines: function(user_id, callback) {
      $.ajax({
        url:"/api/v1/credit_lines",
        data:{
          "user_id": user_id,
        },
        method: "get",
        dataType:"json",
        success: function(data){
          callback(null, data)
          console.log("success");
        },
        error: function(xhr, status, error){
          console.log(error)
        }
      });
    },
    formatDate: function(date) {
      if (!date){
        return ""
      }

      return  date.split("T")[0]
    },

    numberToCurrency: function(number){
       if(!number){
        return "";
       }
       return (Number(number)).toLocaleString('en-US', {style: 'currency', currency: 'USD',}); 
    }
}