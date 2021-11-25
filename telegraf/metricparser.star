load("json.star", "json")
load("time.star", "time")
def apply(metric):

    metrics = []
    new_metric = Metric(metric.name)
    # Add all tags to the new metric
    for k, v in metric.tags.items():
        new_metric.tags[k] = v

    # Create field keys
    for k in metric.fields.items():
        if k[0].endswith("_data_name"): # debug
            print(k[0])

        new_metric.fields[k[0]] = k[1]
    # If property object contains timestmap field then set its value as datapoint time
    timestampField = metric.tags["capability"]+"_"+ metric.tags["property"]+"_timestamp"
    if (metric.fields.get(timestampField)!=None):
        new_metric.time = time.parse_time(metric.fields[timestampField]).unix_nano

    metrics.append(new_metric)
    print(metrics) #  Debug


    return metrics