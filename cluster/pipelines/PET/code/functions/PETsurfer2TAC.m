function BIDS = PETsurfer2TAC(BIDS)

output_dir = fullfile(BIDS.pth,'derivatives',BIDS.config.env.derivatives_dir);

for idx = 1:numel(BIDS.subjects)
    subj = BIDS.subjects(idx).name;
    ses = BIDS.subjects(idx).session;

    pvc_dir = fullfile(output_dir, subj, ses, ...
        'pet', BIDS.config.preproc.pvc.pvc);

    hb_file = fullfile(pvc_dir,'km.hb.tac.dat');

    ref_file = fullfile(pvc_dir,'km.ref.tac.dat');

    nopvc_file = fullfile(pvc_dir,'nopvc.nii.gz');

    gtm_file = fullfile(pvc_dir,'gtm.nii.gz');

    gtm_stats = fullfile(pvc_dir,'gtm.stats.dat');

    metadata = bids.query(BIDS, 'metadata', 'sub', subj, 'ses', ses, ...
        'modality', 'pet', 'suffix', 'pet');

    tacs.frame_start = padarray(cumsum(metadata.FrameDuration(1:end-1)),[1,0],0,'pre');
    tacs.frame_end = tacs.frame_start+metadata.FrameDuration;
    tacs.highbinding = load(hb_file);

    switch BIDS.config.preproc.pvc.pvc
        case 'gtm'
            tac_file = gtm_file;
        case 'nopvc'
            tac_file = nopvc_file;
        case 'agtm'
            tac_file = gtm_file;
    end

    if ~strcmp(BIDS.config.preproc.pvc.pvc,'nopvc')
    tacs_fs = MRIread(tac_file);
    tacs_fs_hdr = readtable(gtm_stats);

    for regs = 1:100
        eval(['tacs.' strrep(lower(tacs_fs_hdr.Var3{regs}),'-','_') ' = squeeze(tacs_fs.vol(1,' num2str(regs) ',1,:));']);
    end

    tacs.reference = load(ref_file);

    tac_file = fullfile(output_dir, subj, ses, ...
        'pet', [subj '_' ses '_pvc-' ...
        BIDS.config.preproc.pvc.pvc ...
        '_desc-mc_tacs.tsv']);

    bids.util.tsvwrite(tac_file, tacs);
    end
    
    tacs_fs = MRIread(nopvc_file);
    tacs_fs_hdr = readtable(gtm_stats);

    for regs = 1:100
        eval(['tacs.' strrep(lower(tacs_fs_hdr.Var3{regs}),'-','_') ' = squeeze(tacs_fs.vol(1,' num2str(regs) ',1,:));']);
    end

    tacs.reference = load(ref_file);

    tac_file = fullfile(output_dir, subj, ses, ...
        'pet', [subj '_' ses '_pvc-nopvc' ...
        '_desc-mc_tacs.tsv']);

    bids.util.tsvwrite(tac_file, tacs);

end