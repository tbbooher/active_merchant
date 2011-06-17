module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class X-chargeGateway < Gateway
      TEST_URL = 'https://test.t3secure.net/x-chargeweb.dll'
      LIVE_URL = 'https://gw.t3secure.net/x-chargeweb.dll'
      
      # The countries the gateway supports merchants from as 2 digit ISO country codes
      self.supported_countries = ['US']
      
      # The card types supported by the payment gateway
      self.supported_cardtypes = [:visa, :master, :american_express, :discover]
      
      # The homepage URL of the gateway
      self.homepage_url = 'http://www.x-charge.com/'
      
      # The name of the gateway
      self.display_name = 'X-Charge'
      
      def initialize(options = {})
        #requires!(options, :login, :password)
        @options = options
        super
      end  
      
      def authorize(money, creditcard, options = {})
        params = {
          :TransactionType => "CreditAuthTransaction",
          :CustomerPresent => "FALSE",
          :CardPresent => "FALSE",
          
        }
        add_invoice(post, options)
        add_creditcard(post, creditcard)        
        add_address(post, creditcard, options)        
        add_customer_data(post, options)
        
        commit('authonly', money, post)
      end
      
      def purchase(money, creditcard, options = {})
        post = {}
        add_invoice(post, options)
        add_creditcard(post, creditcard)        
        add_address(post, creditcard, options)   
        add_customer_data(post, options)
             
        commit('sale', money, post)
      end                       
    
      def capture(money, authorization, options = {})
        commit('capture', money, post)
      end
    
      private                       
      
      def add_customer_data(post, options)
      end

      def add_address(post, creditcard, options)      
      end

      def add_invoice(post, options)
      end
      
      def add_creditcard(params, creditcard)     
         params.merge!(
          :AcctNum  => creditcard.number,
          :ExpDate  => format(creditcard.month, :two_digits)+format(creditcard.year, :four_digits),
         )
         
         params.merge(:CardCode => creditcard.verification_value) if creditcard.verification_value
      end
      
      def parse(body)
      end     
      
      def commit(action, parameters)
        parse(ssl_get(test? ? TEST_URL : LIVE_URL, build_request(action, parameters))))
      end

      def message_from(response)
      end
      
      def post_data(action, parameters = {})
      end
    end
  end
end

