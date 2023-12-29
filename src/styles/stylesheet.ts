const styleSheet = {
    grid: {
        grid: {
            flex: 1,
        },
        row: {
            flex: 1,
            flexDirection: "row",
            alignItems: "center",
        },
        col: {
            flex: 1,
        },
    },
    card: {
        card: {margin: 15, padding: 10},
        content: {marginHorizontal: 0, paddingHorizontal: 10},
    },
    bottomBar: {
        backgroundColor: 'aquamarine',
        position: 'absolute',
        left: 0,
        right: 0,
        bottom: 0,
    },
    fab: {
        position: 'absolute',
        right: 16
    },
    chip: {
        measure: {
            display: "flex",
            // marginLeft: "auto",
        },
        measure_text: {
            textAlign: "right"
        }
    },
    modal: {
        simple: {
            container: {
                display: "flex",
                padding: 20,
                alignSelf: "center",
            },
            title: {
                textAlign: "center",
                marginBottom: 10
            },
            closeButton: {
                marginTop: 10
            }
        },

    }
}

export default styleSheet;