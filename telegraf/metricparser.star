load("json.star", "json")
def apply(metric):

    metrics = []
    new_metric = Metric(metric.tags.get("capability"))
    # Add all tags to the new metric
    for k, v in metric.tags.items():
        new_metric.tags[k] = v

    # Create field keys
    for k in metric.fields.items():
        if k[0].endswith("_data_name"): # debug
            print(k[0])
        new_metric.fields[k[0]] = k[1]
    metrics.append(new_metric)
    print(metrics) #  Debug

    return metrics