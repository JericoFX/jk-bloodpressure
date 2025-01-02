return {
    -- Normal Values
    systolic = 120, 
    diastolic = 80,
    ---#region LOW BLOOD PRESSURE
    lowItems = { -- Name of the items that low the blood pressure 
        beer = 3,
        vodka = 5,
        wine = 2,
    },
    lowEffect = {
        blur = true,
        ragdoll = true,
        fade = true
    },
    hiItems = {
        chocolate = 2,
        "sugaritems",
        "caffe" = 1
    },
    hiEffect = {
        blur = true,
        ragdoll = true,
        fade = true,
        vignnete = true
    }
}