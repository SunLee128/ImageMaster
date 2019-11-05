def run_sql(sql)
    conn = PG.connect(ENV['DATABASE_URL']||{dbname: "pantrymaster"})
    records = conn.exec(sql)
    conn.close
    return records
end

