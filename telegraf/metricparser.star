load("json.star", "json")
load("time.star", "time")
load("logging.star", "log")
def apply(metric):

    metrics = []
    new_metric = Metric(metric.name)
    print(metric)
    propertyName = metric.tags["capability"]+"_"+ metric.tags["property"]+"_"
    timestampField = propertyName+"timestamp"

    if(metric.tags.get("message_id") !=None):
        new_metric.fields["message_id"] = metric.tags["message_id"]
        metric.tags.pop("message_id")


    # Create field keys
    for k in metric.fields.items():
        if k[0].endswith("_data_name"):
            if (metric.fields.get(propertyName+"data_state")!=None):
                newFieldName = propertyName + metric.fields.get(propertyName + "data_name")
                new_metric.fields[newFieldName] = metric.fields.get(propertyName + "data_state")
        if k[0].endswith("_data_unit"):
            for valueParameter in metric.fields.items():
                if valueParameter[0].endswith("_data_value"):
                    newFieldUnitName = valueParameter[0].replace("data_value", k[1])
                    new_metric.fields[newFieldUnitName] = valueParameter[1]
        new_metric.fields[k[0]] = k[1]

    # If property object contains timestamp field then set its value as datapoint time value else use the timestamp tag value
    fieldTimestamp = False
    if (metric.fields.get(timestampField)!=None):
        new_metric.time = time.parse_time(metric.fields[timestampField]).unix_nano
        fieldTimestamp = True

    if ( fieldTimestamp==False and metric.tags.get("timestamp")!=None):

        new_metric.time = time.parse_time(metric.tags["timestamp"]).unix_nano
        print(new_metric.time)




    # Add all tags to the new metric
    for k, v in metric.tags.items():
        new_metric.tags[k] = v

    metrics.append(new_metric)
    print(metrics)
    return metrics