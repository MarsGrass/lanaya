#ifndef TERMSQL_H
#define TERMSQL_H

#define TERM_LIST           "select code from gas_terminal;"

#define TERM_FREQ           "update gas_terminal set sample_freq = %1 where code = '%2';"

#define TERM_CMD_LIST       "select gas_terminal_cmd.terminal_code, gas_terminal_cmd.content, gas_terminal_cmd.id "\
                            "from gas_terminal_cmd, gas_terminal "\
                            "where gas_terminal_cmd.exec_status = 0 and gas_terminal_cmd.terminal_code = gas_terminal.code "\
                            "and gas_terminal.run_status = 1 limit 1;"

#define TERM_CMD_COMP       "update gas_terminal_cmd set exec_status = 1, exec_time = now() where id = %1;"

#define TERM_ON             "update gas_terminal set link_status = 1, run_status = 1 where code = '%1';"
#define TERM_OFF            "update gas_terminal set link_status = 2, run_status = 2 where code = '%1';"

#define TERM_INSERT         "insert into gas_terminal (code, name, group_id) value ('%1', '%2', 1);"

#define TERM_DATA_INSERT    "insert into gas_sensor_data (skey, data, report_time, terminal_code, sensor_code) "\
                                    "value ('%1_%2', %3, '%4', '%5', '%6');"


#endif // TERMSQL_H
