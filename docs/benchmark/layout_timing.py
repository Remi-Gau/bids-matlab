from pathlib import Path

from bids import BIDSLayout

import pandas as pd

from rich import print

import time


def main():

    debug = False

    nb_runs = 10

    pth_bids_example = Path(__file__).parent.parent.parent.joinpath(
        "tests", "bids-examples"
    )

    datasets = pth_bids_example.glob("*")

    tsv_content = {"dataset": [], "nb_files": []}
    for r in range(nb_runs):
        tsv_content[f"time_{r}"] = []

    for i, d in enumerate(datasets):

        if d.is_dir() and d.name not in [".git", ".github"]:

            print(f"{d.name}: ", end="")

            for r in range(nb_runs):

                print(".", end="")

                start = time.time()
                layout = BIDSLayout(d)
                end = time.time()

                tsv_content[f"time_{r}"].append(end - start)

                if r == 0:

                    tsv_content["dataset"].append(d.name)

                    nb_files = len(layout.get(return_type="file"))
                    tsv_content["nb_files"].append(nb_files)

            print()

        if debug and i > 5:
            break

    df = pd.DataFrame(data=tsv_content)
    df.to_csv("pybids.tsv", sep="\t", index=False)


if __name__ == "__main__":
    main()
