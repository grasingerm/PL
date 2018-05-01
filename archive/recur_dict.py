def recur_det_lev(curr, where_am_i_now):
    if type(curr) == dict:
        for k, v in curr.items():
            c_where_am_i_now = list(where_am_i_now)
            c_where_am_i_now.append(k)
            recur_det_lev(v, c_where_am_i_now)
    else:
        for path in where_am_i_now:
            print(path, " => ", end="")
        print(curr)

d = {
    "yolo": 23,
    "nolo": "solo",
    "uno": 1,
    "dos": 2,
    "some_other_dict": {
        "kiss_it_all_better":"I'm not ready to go",
        "its not your fault": {
            "you didn't know": "you didn't",
            "how could you know?": "you couldn't"
        }
    },
    "everything will be alright": "liar"
}

recur_det_lev(d, ["root"])
