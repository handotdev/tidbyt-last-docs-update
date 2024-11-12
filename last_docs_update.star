"""
Applet: Last Docs Update
Summary: Last docs update
Description: The last time an update was made to the Mintlify docs.
Author: handotdev
"""

load("render.star", "render")
load("http.star", "http")
load("time.star", "time")

MINTLIFY_DOCS_GITHUB_COMMITS_ENDPOINT = "https://api.github.com/repos/mintlify/docs/commits"

def main():
    rep = http.get(MINTLIFY_DOCS_GITHUB_COMMITS_ENDPOINT, ttl_seconds=60)
    if rep.status_code != 200:
        fail("Unable to fetch request %d", rep.status_code)

    last_commit_date = rep.json()[0]["commit"]["author"]["date"]
    
    now = time.now()

    last_commit_datetime = time.parse_time(last_commit_date)
    
    time_difference = now - last_commit_datetime

    days_since_last_update = int(time_difference.minutes / (24 * 60))
    hours_since_last_update = int((time_difference.minutes / 60) % 24)
    minutes_since_last_update = int(time_difference.minutes % 60)

    return render.Root(
        delay = 3000,
        child = render.Animation(
            children=[
                render.Box(
                    padding = 2,
                    child = render.Column(
                        expanded=True,
                        main_align="space_evenly",
                        children = [
                            render.Row(
                                children=[render.Text(content = str(days_since_last_update), color="#55D799"), render.Text(content = " days")]
                            ),
                            render.Row(
                                children=[render.Text(content = str(hours_since_last_update), color="#55D799"), render.Text(content = " hours")]
                            ),
                            render.Row(
                                children=[render.Text(content = str(minutes_since_last_update), color="#55D799"), render.Text(content = " minutes")]
                            ),
                        ],
                    ),
                ),
                render.Box(
                    padding = 2,
                    child = render.Column(
                        expanded=True,
                        main_align="space_evenly",
                        children = [
                            render.WrappedText(content = "since last docs update"),
                        ],
                    ),
                ),
            ],
        )
    )