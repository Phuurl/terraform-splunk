import sys


def icm(num_sites):
    sites_string = ""
    for i in range(int(sys.argv[2])):
        sites_string += "site{},".format(str(i + 1))
    # Remove trailing comma
    return sites_string[:len(sites_string) - 1]


def idx(num_indexers, num_sites, num_current_idx):
    num_idx_per_site = num_indexers / num_sites
    num_leftover = num_indexers % num_sites

    site_array = []
    for i in range(num_sites):
        site_array.append(num_idx_per_site)
        if num_leftover > 0:
            site_array[i] = site_array[i] + 1
            num_leftover -= 1
        num_current_idx -= site_array[i]
        if num_current_idx <= 0:
            sites_string = "site{}".format(str(i + 1))
            break
    return sites_string


if __name__ == "__main__":
    if sys.argv[1] == "icm":
        print(icm(int(sys.argv[2])))
    elif sys.argv[1] == "idx":
        print(idx(int(sys.argv[2]), int(sys.argv[3]), int(sys.argv[4])))
