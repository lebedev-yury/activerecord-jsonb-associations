# rubocop:disable Metrics/BlockLength
RSpec.shared_examples ':has_one with JSONB store' do
  let(:child_name) { child_model.model_name.element }

  describe '#association' do
    before do
      child_model.update
    end
  end

  describe '#association' do
    before do
      child_model.send "#{store}=", foreign_key => parent_model.id
      child_model.save
    end

    it 'properly loads association from parent model' do
      expect(parent_model.reload.send(child_name)).to eq(child_model)
    end
  end

  describe '#association=' do
    before do
      parent_model.send "#{child_name}=", child_model
    end

    it 'sets and persists foreign key on child model' do
      expect(
        child_model.reload.send(store)
      ).to eq(foreign_key.to_s => parent_model.id)
    end
  end

  describe 'association_id' do
    before do
      child_model.send(store)[foreign_key.to_s] = parent_model.id
    end

    it 'reads foreign id from specified :store column by foreign key' do
      expect(child_model.send(foreign_key)).to eq parent_model.id
    end
  end

  describe '#association_id=' do
    before do
      child_model.send "#{foreign_key}=", parent_model.id
    end

    it 'sets foreign id in specified :store column as hash item' do
      expect(child_model.send(store)[foreign_key.to_s]).to eq(parent_model.id)
    end
  end

  describe '#build_association' do
    let(:built_association) do
      parent_model.send "build_#{child_name}"
    end

    it 'sets foreign key on child model' do
      expect(
        built_association.send(store)
      ).to eq(foreign_key.to_s => parent_model.id)
    end
  end

  describe '#create_association' do
    let(:created_association) do
      parent_model.send "create_#{child_name}"
    end

    it 'sets and persists foreign key on child model' do
      expect(
        created_association.reload.send(store)
      ).to eq(foreign_key.to_s => parent_model.id)
    end
  end

  describe '#reload_association' do
    before do
      parent_model.send "#{child_name}=", child_model
    end

    it 'reloads association' do
      expect(parent_model.send("reload_#{child_name}")).to eq(child_model)
    end
  end

  describe '#preload / #includes' do
    let(:parent_class) do
      parent_model.class
    end

    let(:child_class) do
      child_model.class
    end

    before do
      parent_class.destroy_all
      3.times do
        parent_instance = parent_class.create
        parent_instance.send "create_#{child_name}"
      end
    end

    it 'preloads association' do
      expect(count_queries do
        records = parent_class.all.preload(child_name)
        records.map do |record|
          record.send(child_name).id
        end
      end).to eq(2)
    end
  end

  describe '#eager_load / #joins' do
    let(:parent_class) do
      parent_model.class
    end

    let(:child_class) do
      child_model.class
    end

    before do
      parent_class.destroy_all
      3.times do
        parent_instance = parent_class.create
        parent_instance.send "create_#{child_name}"
      end
    end

    it 'preloads association' do
      expect(count_queries do
        parent_class.all.eager_load(child_name).map do |record|
          record.send(child_name)
        end
      end).to eq(1)
    end
  end
end
# rubocop:enable Metrics/BlockLength

RSpec.describe ':has_one' do
  context 'regular association' do
    let(:parent_model) { User.create }
    let(:child_model) { Profile.new }
    let(:child_name) { child_model.model_name.element }
  end

  context 'association with :store option set on child model' do
    let(:child_model) { Account.new }
    let(:store) { :extra }

    context 'with default options' do
      let(:parent_model) { User.create }
      let(:foreign_key) { :user_id }

      include_examples ':has_one with JSONB store'
    end

    context 'with non-default :options' do
      let(:parent_model) { GoodsSupplier.create }
      let(:foreign_key) { :supplier_id }

      include_examples ':has_one with JSONB store'
    end
  end
end
