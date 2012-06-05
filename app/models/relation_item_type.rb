## Used to populate values on the User Profile UI for filtering the Karma Live View

class RelationItemType
  attr_accessor :id, :name
  
  def initialize(id, name)
    @id = id
    @name = name
  end
  
  def self.get_relation_item_types
    a = [
          self.ONLY_MINE,
          self.INTERNAL_COWORKERS,
          self.EXTERNAL_COLLEAGUES,
          self.ALL_PROFESSIONAL_CONTACTS
        ]
  end
  # All Professional Contacts is both internal and exernal
  # Internal will not overlap with external

  # Only Mine
  def self.ONLY_MINE
    RelationItemType.new(1, 'Only Mine')
  end
  
  def self.INTERNAL_COWORKERS
    RelationItemType.new(2, "Internal Coworkers")
  end
  
  def self.EXTERNAL_COLLEAGUES
    RelationItemType.new(3, "External Colleagues")
  end
  
  def self.ALL_PROFESSIONAL_CONTACTS
    RelationItemType.new(4, "All Professional Contacts")
  end

# Old

  # Internal Coworkers
  def self.WITHIN_MY_COMPANY
    RelationItemType.new(11, 'Within My Company')
  end
  # External Colleagues
  def self.COMPANY_CUSTOMERS
    RelationItemType.new(13, 'Company Customers')
  end
  # External Colleagues
  def self.BUSINESS_PARTNERS
    RelationItemType.new(14, 'Business Partners')
  end
  # External Colleagues
  def self.SERVICE_PROVIDERS
    RelationItemType.new(15, 'Service Providers')
  end
  
  def self.ALL_MY_NETWORK
    RelationItemType.new(16, 'All My Network')
  end
  
end