require 'gs2/core/AbstractClient.rb'

module Gs2 module Identifier
  
  # GS2-Identifier クライアント
  #
  # @author Game Server Services, Inc.
  class Client < Gs2::Core::AbstractClient
  
    @@ENDPOINT = 'identifier'
  
    # コンストラクタ
    # 
    # @param region [String] リージョン名
    # @param gs2_client_id [String] GSIクライアントID
    # @param gs2_client_secret [String] GSIクライアントシークレット
    def initialize(region, gs2_client_id, gs2_client_secret)
      super(region, gs2_client_id, gs2_client_secret)
    end
    
    # デバッグ用。通常利用する必要はありません。
    def self.ENDPOINT(v = nil)
      if v
        @@ENDPOINT = v
      else
        return @@ENDPOINT
      end
    end

    # ユーザリストを取得
    # 
    # @param pageToken [String] ページトークン
    # @param limit [Integer] 取得件数
    # @return [Array]
    #  * items
    #    [Array]
    #      * userId => ユーザID
    #      * ownerId => オーナーID
    #      * name => ユーザ名
    #      * createAt => 作成日時
    #  * nextPageToken => 次ページトークン
    def describe_user(pageToken = nil, limit = nil)
      query = {}
      if pageToken; query['pageToken'] = pageToken; end
      if limit; query['limit'] = limit; end
      return get(
            'Gs2Identifier', 
            'DescribeUser', 
            @@ENDPOINT, 
            '/user',
            query);
    end

    # ユーザを作成<br>
    # <br>
    # GS2のサービスを利用するにはユーザを作成する必要があります。<br>
    # ユーザを作成後、ユーザに対して権限設定を行い、ユーザに対応したGSI(クライアントID/シークレット)を発行することでAPIが利用できるようになります。<br>
    # 
    # @param request [Array]
    #   * name => ユーザ名
    # @return [Array]
    #   * item
    #     * userId => ユーザID
    #     * ownerId => オーナーID
    #     * name => ユーザ名
    #     * createAt => 作成日時
    def create_user(request)
      if not request; raise ArgumentError.new(); end
      body = {}
      if request.has_key?('name'); body['name'] = request['name']; end
      query = {}
      return post(
            'Gs2Identifier', 
            'CreateUser', 
            @@ENDPOINT, 
            '/user',
            body,
            query);
    end

    # ユーザを取得
    #
    # @param request [Array]
    #   * userName => ユーザ名
    # @return [Array]
    #   * item
    #     * userId => ユーザID
    #     * ownerId => オーナーID
    #     * name => ユーザ名
    #     * createAt => 作成日時
    def get_user(request)
      if not request; raise ArgumentError.new(); end
      if not request.has_key?('userName'); raise ArgumentError.new(); end
      query = {}
      return get(
          'Gs2Identifier',
          'GetUser',
          @@ENDPOINT,
          '/user/' + request['userName'],
          query);
    end

    # ユーザを削除
    # 
    # @param request [Array]
    #   * userName => ユーザ名
    def delete_user(request)
      if not request; raise ArgumentError.new(); end
      if not request.has_key?('userName'); raise ArgumentError.new(); end
      if not request['userName']; raise ArgumentError.new(); end
      query = {}
      return delete(
            'Gs2Identifier', 
            'DeleteUser', 
            @@ENDPOINT, 
            '/user/' + request['userName'],
            query);
    end

    # GSIリストを取得
    # 
    # @param request [Array]
    #   * userName => ユーザ名
    # @param pageToken [String] ページトークン
    # @param limit [Integer] 取得件数
    # @return [Array]
    #   * items
    #     [Array]
    #       * identifierId => GSIID
    #       * ownerId => オーナーID
    #       * clientId => クライアントID
    #       * createAt => 作成日時
    #   * nextPageToken => 次ページトークン
    def describe_identifier(request, pageToken = nil, limit = nil)
      if not request; raise ArgumentError.new(); end
      if not request.has_key?('userName'); raise ArgumentError.new(); end
      if not request['userName']; raise ArgumentError.new(); end
      query = {}
      if pageToken; query['pageToken'] = pageToken; end
      if limit; query['limit'] = limit; end
      return get(
          'Gs2Identifier',
          'DescribeIdentifier',
          @@ENDPOINT,
          '/user/' + request['userName'] + '/identifier',
          query);
    end

    # GSIを作成<br>
    # <br>
    # GSIはSDKなどでAPIを利用する際に必要となる クライアントID/シークレット です。<br>
    # AWSでいうIAMのクレデンシャルに相当します。<br>
    # 
    # @param request [Array]
    #   * userName => ユーザ名
    # @return [Array]
    #   * item
    #     * identifierId => GSIID
    #     * ownerId => オーナーID
    #     * clientId => クライアントID
    #     * clientSecret => クライアントシークレット
    #     * createAt => 作成日時
    def create_identifier(request)
      if not request; raise ArgumentError.new(); end
      if not request.has_key?('userName'); raise ArgumentError.new(); end
      if not request['userName']; raise ArgumentError.new(); end
      body = {}
      query = {}
      return post(
          'Gs2Identifier',
          'CreateIdentifier',
          @@ENDPOINT,
          '/user/' + request['userName'] + '/identifier',
          body,
          query);
    end

    # GSIを削除
    # 
    # @param request [Array]
    #   * userName => ユーザ名
    #   * identifierId => GSI ID
    def delete_identifier(request)
      if not request; raise ArgumentError.new(); end
      if not request.has_key?('userName'); raise ArgumentError.new(); end
      if not request['userName']; raise ArgumentError.new(); end
      if not request.has_key?('identifierId'); raise ArgumentError.new(); end
      if not request['identifierId']; raise ArgumentError.new(); end
      query = {}
      return delete(
          'Gs2Identifier',
          'DeleteIdentifier',
          @@ENDPOINT,
          '/user/' + request['userName'] + '/identifier/' + request['identifierId'],
          query);
    end

    # ユーザが保持しているセキュリティポリシー一覧を取得
    #
    # @param request [Array]
    #   * userName => ユーザ名
    # @return [Array]
    #   * items
    #     [Array]
    #       * identifierId => GSIID
    #       * ownerId => オーナーID
    #       * clientId => クライアントID
    #       * createAt => 作成日時
    def get_has_security_policy(request)
      if not request; raise ArgumentError.new(); end
      if not request.has_key?('userName'); raise ArgumentError.new(); end
      if not request['userName']; raise ArgumentError.new(); end
      query = {}
      return get(
          'Gs2Identifier',
          'HasSecurityPolicy',
          @@ENDPOINT,
          '/user/' + request['userName'] + '/securityPolicy',
          query);
    end

    # ユーザにセキュリティポリシーを割り当てる
    #
    # @param request [Array]
    #   * userName => ユーザ名
    #   * securityPolicyId => セキュリティポリシーID
    def attach_security_policy(request)
      if not request; raise ArgumentError.new(); end
      if not request.has_key?('userName'); raise ArgumentError.new(); end
      if not request['userName']; raise ArgumentError.new(); end
      body = {}
      if request.has_key?('securityPolicyId'); body['securityPolicyId'] = request['securityPolicyId']; end
      query = {}
      return put(
          'Gs2Identifier',
          'AttachSecurityPolicy',
          @@ENDPOINT,
          '/user/' + request['userName'] + '/securityPolicy',
          body);
    end

    # ユーザに割り当てられたセキュリティポリシーを解除
    #
    # @param request [Array]
    #   * userName => ユーザ名
    #   * securityPolicyId => セキュリティポリシーID
    def detach_security_policy(request)
      if not request; raise ArgumentError.new(); end
      if not request.has_key?('userName'); raise ArgumentError.new(); end
      if not request['userName']; raise ArgumentError.new(); end
      if not request.has_key?('securityPolicyId'); raise ArgumentError.new(); end
      if not request['securityPolicyId']; raise ArgumentError.new(); end
      query = {}
      return delete(
          'Gs2Identifier',
          'DetachSecurityPolicy',
          @@ENDPOINT,
          '/user/' + request['userName'] + '/securityPolicy/' + request['securityPolicyId'],
          query);
    end

    # セキュリティポリシーリストを取得
    #
    # @param pageToken [String] ページトークン
    # @param limit [Integer] 取得件数
    # @return [Array]
    #   * items
    #     [Array]
    #       * securityPolicyId => セキュリティポリシーID
    #        * ownerId => オーナーID
    #       * name => セキュリティポリシー名
    #        * policy => ポリシー
    #        * createAt => 作成日時
    #       * updateAt => 更新日時
    #   * nextPageToken => 次ページトークン
    def describe_security_policy(pageToken = nil, limit = nil)
      query = {}
      if pageToken; query['pageToken'] = pageToken; end
      if limit; query['limit'] = limit; end
      return get(
          'Gs2Identifier',
          'DescribeSecurityPolicy',
          @@ENDPOINT,
          '/securityPolicy',
          query);
    end

    # 共用セキュリティポリシーリストを取得
    #
    # @param pageToken [String] ページトークン
    # @param limit [Integer] 取得件数
    # @return [Array]
    #   * items
    #     [Array]
    #       * securityPolicyId => セキュリティポリシーID
    #       * ownerId => オーナーID
    #       * name => セキュリティポリシー名
    #       * policy => ポリシー
    #       * createAt => 作成日時
    #       * updateAt => 更新日時
    #   * nextPageToken => 次ページトークン
    def describe_common_security_policy(pageToken = nil, limit = nil)
      query = {}
      if pageToken; query['pageToken'] = pageToken; end
      if limit; query['limit'] = limit; end
      return get(
          'Gs2Identifier',
          'DescribeSecurityPolicy',
          @@ENDPOINT,
          '/securityPolicy/common',
          query);
    end
  
    # セキュリティポリシーを作成<br>
    # <br>
    # セキュリティポリシーはユーザの権限を定義したものです。<br>
    # AWSのIAMポリシーに似せて設計されていますが、いくつかAWSのIAMポリシーと比較して劣る点があります。<br>
    # 2016/9 時点では以下の様な点が IAMポリシー とは異なります。<br>
    # 
    # * リソースに対するアクセス制御はできません。
    # * アクションのワイルドカードは最後に1箇所のみ利用できます。
    #
    # @param array request
    #  * name => セキュリティポリシー名
    #  * policy => ポリシー
    # @return array
    #  * item
    #    * securityPolicyId => セキュリティポリシーID
    #    * ownerId => オーナーID
    #    * name => セキュリティポリシー名
    #    * policy => ポリシー
    #    * createAt => 作成日時
    #    * updateAt => 更新日時
    def create_security_policy(request)
      if not request; raise ArgumentError.new(); end
      body = {}
      if request.has_key?('name'); body['name'] = request['name']; end
      if request.has_key?('policy'); body['policy'] = request['policy']; end
      query = {}
      return post(
          'Gs2Identifier',
          'CreateSecurityPolicy',
          @@ENDPOINT,
          '/securityPolicy',
          body,
          query);
    end
    
    # セキュリティポリシーを取得
    #
    # @param request [Array]
    #   * securityPolicyName => セキュリティポリシー名
    # @return [Array]
    #   * item
    #     * securityPolicyId => セキュリティポリシーID
    #     * ownerId => オーナーID
    #     * name => セキュリティポリシー名
    #     * policy => ポリシー
    #     * createAt => 作成日時
    #     * updateAt => 更新日時
    def get_security_policy(request)
      if not request; raise ArgumentError.new(); end
      if not request.has_key?('securityPolicyName'); raise ArgumentError.new(); end
      query = {}
      return get(
          'Gs2Identifier',
          'GetSecurityPolicy',
          @@ENDPOINT,
          '/securityPolicy/' + request['securityPolicyName'],
          query);
    end
    
    # セキュリティポリシーを更新
    #
    # @param request [Array]
    #   * securityPolicyName => セキュリティポリシー名
    # @return [Array]
    #   * item
    #     * securityPolicyId => セキュリティポリシーID
    #     * ownerId => オーナーID
    #     * name => セキュリティポリシー名
    #     * policy => ポリシー
    #     * createAt => 作成日時
    #     * updateAt => 更新日時
    def update_security_policy(request)
      if not request; raise ArgumentError.new(); end
      if not request.has_key?('securityPolicyName'); raise ArgumentError.new(); end
      if not request['securityPolicyName']; raise ArgumentError.new(); end
      body = {}
      if request.has_key?('policy'); body['policy'] = request['policy']; end
      query = {}
      return put(
          'Gs2Identifier',
          'UpdateSecurityPolicy',
          @@ENDPOINT,
          '/securityPolicy/' + request['securityPolicyName'],
          body,
          query);
    end
    
    # セキュリティポリシーを削除
    #
    # @param request [Array]
    #   * securityPolicyName => セキュリティポリシー名
    def delete_security_policy(request)
      if not request; raise ArgumentError.new(); end
      if not request.has_key?('securityPolicyName'); raise ArgumentError.new(); end
      if not request['securityPolicyName']; raise ArgumentError.new(); end
      query = {}
      return delete(
          'Gs2Identifier',
          'DeleteSecurityPolicy',
          @@ENDPOINT,
          '/securityPolicy/' + request['securityPolicyName'],
          query);
    end
  end
end end