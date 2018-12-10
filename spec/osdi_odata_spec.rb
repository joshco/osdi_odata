RSpec.describe OsdiOdata do
  it "has a version number" do
    expect(OsdiOdata::VERSION).not_to be nil
  end

  it "parses and makes SQL" do
    filter="modified_date gt '2018-08-01' or ( gender ne 'Male' and gender ne 'They')"
    sql=OsdiOdata.parse(filter)

    expected="modified_date > '2018-08-01' OR ( gender <> 'Male' AND gender <> 'They' )"
    expect(sql).to eq(expected)
  end

  it "parses with error SQL" do
    filter="modified_date gt '2018-08-01' or ( birthdate.month gt 3 and gender ne 'Male' and gender ne 'They')"
    OsdiOdata.logging_enabled=true

    expect{ sql=OsdiOdata.parse(filter) }.to raise_exception(Exception)


  end
end
