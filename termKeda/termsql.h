#ifndef TERMSQL_H
#define TERMSQL_H

#define TERM_LIST           "select code from gas_terminal;"

#define TERM_ON             "update gas_terminal set link_status = 1, run_status = 1 where code = '%1';"
#define TERM_OFF            "update gas_terminal set link_status = 2, run_status = 2 where code = '%1';"

#define TERM_INSERT         "insert into gas_terminal (code, name, group_id) value ('%1', '%2', 1);"

#define TERM_DATA_INSERT    "insert into gas_sensor_data (skey, data, report_time) value ('%1_%2', %3, '%4');"

#endif // TERMSQL_H
