import omero
import omero.cli

project_name = "idr0157-peters-bryophytes/experimentA"
dry_run = False


if __name__ == "__main__":
    with omero.cli.cli_login() as c:
        conn = omero.gateway.BlitzGateway(client_obj=c.get_client())
        project = conn.getObject("Project", attributes={"name": project_name})
        for dataset in project.listChildren():
            print(f"{dataset.getId()}: {dataset.getName()}")
            for image in dataset.listChildren():
                cur_name = image.getName()
                if "gougetiana var. armatissima" in cur_name:
                    new_name = cur_name.replace("gougetiana var. armatissima", "ciliifera")
                    image.setName(new_name)
                    if not dry_run:
                        conn.getUpdateService().saveAndReturnObject(image._obj, conn.SERVICE_OPTS)
                    print(f"{image.getId()}: {cur_name} -> {image.getName()}")
                if "gougetiana_var_armatissima" in cur_name:
                    new_name = cur_name.replace("gougetiana_var_armatissima", "ciliifera")
                    image.setName(new_name)
                    if not dry_run:
                        conn.getUpdateService().saveAndReturnObject(image._obj, conn.SERVICE_OPTS)
                    print(f"{image.getId()}: {cur_name} -> {image.getName()}")
        conn.close()

    print("Done.")
