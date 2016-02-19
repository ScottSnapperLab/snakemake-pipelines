"""Python functions specific to this snakemake pipeline."""

import pandas as pd

def create_paired_comparisons(dummy_df, pair):
    """Add new comparison column to dummy_df based on info in `pair`.

    Adds NaN values to a new dummy variable column for all but the samples belonging to the columns listed in `pair`.

    Returns: None
    """
    pair_mask = (dummy_df[pair[0]] + dummy_df[pair[1]]).apply(bool)

    dummy_df['{p0}_vs_{p1}'.format(p0=pair[0], p1=pair[1])] = dummy_df.Sample_Type_CD14[pair_mask]


def make_traits_df(in_path, paired_comparisons=None):
    """Generate a dataframe of dummy variables from `in_path`.

    Returns dataframe containing comparisons listed in `in_path` encoded as dummy variables in form expected by
    NanoStringNorm as well as the renamed `anno` dataframe.
    """
    anno = pd.read_excel(in_path)

    # convert file_name into what NanoStringNorm uses for sample names
    anno['File_Name'] = anno.File_Name.apply(lambda i: 'X' + i.rstrip('.RCC').replace(' ','_').replace('+','.'))

    # separate traits columns
    traits = anno.iloc[:,1:]

    # convert trait columns into dummy variables
    traits_dummy = pd.get_dummies(traits.astype(str))


    if paired_comparisons is not None:
        for pair in paired_comparisons:
            create_paired_comparisons(dummy_df=traits_dummy, pair=pair)

    traits_dummy = traits_dummy + 1

    traits_df = anno.File_Name.copy()
    traits_df = pd.concat([traits_df, traits_dummy], axis=1)

    return traits_df,anno
