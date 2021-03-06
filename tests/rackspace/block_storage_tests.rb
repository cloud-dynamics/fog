Shindo.tests('Fog::Rackspace::BlockStorage', ['rackspace']) do

  def assert_method(url, method)
    @service.instance_variable_set "@rackspace_auth_url", url
    returns(method) { @service.send :authentication_method }
  end

  tests('#authentication_method') do
    @service = Fog::Rackspace::BlockStorage.new

    assert_method nil, :authenticate_v2

    assert_method 'auth.api.rackspacecloud.com', :authenticate_v1 # chef's default auth endpoint

    assert_method 'https://identity.api.rackspacecloud.com', :authenticate_v1
    assert_method 'https://identity.api.rackspacecloud.com/v1', :authenticate_v1
    assert_method 'https://identity.api.rackspacecloud.com/v1.1', :authenticate_v1
    assert_method 'https://identity.api.rackspacecloud.com/v2.0', :authenticate_v2

    assert_method 'https://lon.identity.api.rackspacecloud.com', :authenticate_v1
    assert_method 'https://lon.identity.api.rackspacecloud.com/v1', :authenticate_v1
    assert_method 'https://lon.identity.api.rackspacecloud.com/v1.1', :authenticate_v1
    assert_method 'https://lon.identity.api.rackspacecloud.com/v2.0', :authenticate_v2
  end

  tests('legacy authentication') do
    pending if Fog.mocking?

    tests('variables populated').succeeds  do
      @service = Fog::Rackspace::BlockStorage.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v1.0'
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(false, "path populated") { @service.instance_variable_get("@uri").path.nil? }
      returns(true, "identity_service was not used") { @service.instance_variable_get("@identity_service").nil? }
      @service.list_volumes
    end

    tests('custom endpoint')  do
      @service = Fog::Rackspace::BlockStorage.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v1.0',
        :rackspace_block_storage_url => 'https://my-custom-endpoint.com'
        returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
        returns(true, "uses custom endpoint") { (@service.instance_variable_get("@uri").host =~ /my-custom-endpoint\.com/) != nil }
    end
  end

  tests('current authentation') do
    pending if Fog.mocking?

    tests('variables populated').succeeds  do
      @service = Fog::Rackspace::BlockStorage.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v2.0'
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(false, "path populated") { @service.instance_variable_get("@uri").host.nil? }
      returns(false, "identity service was used") { @service.instance_variable_get("@identity_service").nil? }
      @service.list_volumes
    end
    tests('dfw region').succeeds  do
      @service = Fog::Rackspace::BlockStorage.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v2.0', :rackspace_region => :dfw
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(true) { (@service.instance_variable_get("@uri").host =~ /dfw/) != nil }
      @service.list_volumes
    end
    tests('ord region').succeeds do
      @service = Fog::Rackspace::BlockStorage.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v2.0', :rackspace_region => :ord
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(true) { (@service.instance_variable_get("@uri").host =~ /ord/) != nil }
      @service.list_volumes
    end
    tests('custom endpoint') do
      @service = Fog::Rackspace::BlockStorage.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v2.0',
        :rackspace_block_storage_url => 'https://my-custom-endpoint.com'
        returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
        returns(true, "uses custom endpoint") { (@service.instance_variable_get("@uri").host =~ /my-custom-endpoint\.com/) != nil }
    end
  end

  tests('default auth') do
    pending if Fog.mocking?

    tests('no params').succeeds do
      @service = Fog::Rackspace::BlockStorage.new
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(true) { (@service.instance_variable_get("@uri").host =~ /dfw/) != nil }
      @service.list_volumes
    end
    tests('specify old contstant style service endoint').succeeds do
      @service = Fog::Rackspace::BlockStorage.new :rackspace_endpoint =>  Fog::Rackspace::BlockStorage::ORD_ENDPOINT
      @service.list_volumes
    end
    tests('specify region') do
      @service = Fog::Rackspace::BlockStorage.new :rackspace_region => :ord
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(true) { (@service.instance_variable_get("@uri").host =~ /ord/ ) != nil }
      @service.list_volumes
    end
    tests('custom endpoint') do
      @service = Fog::Rackspace::BlockStorage.new :rackspace_block_storage_url => 'https://my-custom-endpoint.com'
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(true, "uses custom endpoint") { (@service.instance_variable_get("@uri").host =~ /my-custom-endpoint\.com/) != nil }
    end
  end

end