load("json.star", "json")
load("time.star", "time")
def apply(metric):

    metrics = []
    new_metric = Metric(metric.name)
    propertyName = metric.tags["capability"]+"_"+ metric.tags["property"]+"_"
    timestampField = propertyName+"timestamp"

    # Create field keys
    for k in metric.fields.items():
        if k[0].endswith("_data_name"): # debug
            if (metric.fields.get(propertyName+"data_state")!=None):
                newtagName = propertyName + metric.fields.get(propertyName + "data_name")
                new_metric.fields[newtagName] = metric.fields.get(propertyName + "data_state")
        new_metric.fields[k[0]] = k[1]

    # If property object contains timestmap field then set its value as datapoint time
    if (metric.fields.get(timestampField)!=None):
        new_metric.time = time.parse_time(metric.fields[timestampField]).unix_nano

    # Add all tags to the new metric
    for k, v in metric.tags.items():
        new_metric.tags[k] = v

    metrics.append(new_metric)
    return metrics